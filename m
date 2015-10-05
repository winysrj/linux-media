Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32132 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbbJEMYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 08:24:46 -0400
Message-id: <56126BD2.3060004@samsung.com>
Date: Mon, 05 Oct 2015 14:23:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene@kernel.org>
Subject: Re: [PATCH 5/7] [media] mipi-csis: make sparse happy
References: <cover.1443737682.git.mchehab@osg.samsung.com>
 <4962836.RxBJeKxGZM@wuerfel> <56124FE8.8070400@samsung.com>
 <30256208.KbAtSBWnKO@wuerfel>
In-reply-to: <30256208.KbAtSBWnKO@wuerfel>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/10/15 13:07, Arnd Bergmann wrote:
> On Monday 05 October 2015 12:24:40 Sylwester Nawrocki wrote:
>> > On 03/10/15 00:25, Arnd Bergmann wrote:
>>> > > On Thursday 01 October 2015 19:17:27 Mauro Carvalho Chehab wrote:
>>>>> > >> > diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
>>>>> > >> > index d74e1bec3d86..4b85105dc159 100644
>>>>> > >> > --- a/drivers/media/platform/exynos4-is/mipi-csis.c
>>>>> > >> > +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
>>>>> > >> > @@ -706,7 +706,8 @@ static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
>>>>> > >> >                 else
>>>>> > >> >                         offset = S5PCSIS_PKTDATA_ODD;
>>>>> > >> >  
>>>>> > >> > -               memcpy(pktbuf->data, state->regs + offset, pktbuf->len);
>>>>> > >> > +               memcpy(pktbuf->data, (u8 __force *)state->regs + offset,
>>>>> > >> > +                      pktbuf->len);
>>>>> > >> >                 pktbuf->data = NULL;
>>>>> > >> > 
>>> > >
>>> > > I think this is what memcpy_toio() is meant for.
>> > 
>> > Exactly memcpy_fromio().  But it's implementation is inefficient on
>> > ARCH=arm, memcpy_fromio() will be translated to a loop of readb(),
>> > only if an arm sub-architecture provides a processor instruction
>> > to access memory by byte.  Each readb() also involves a memory barrier.
>> > That's all what we wanted to avoid. AFAIR using memcpy_fromio() was
>> > causing increase of the copy operation several times comparing to
>> > memcpy(). On arm64 it looks better, but this driver is currently
>> > used only on arm32.
>> > 
>> > I would prefer to add (void __force *) instead:
>> > 
>> > memcpy(pktbuf->data, (void __force *)state->regs + offset, pktbuf->len);
>> > 
>> > Alternatively, the memset could just be replaced by a loop of
>> > u32 reads - __raw_readl();
>
> You are right for old kernels, but this was fixed in 7ddfe625cb ("ARM:
> optimize memset_io()/memcpy_fromio()/memcpy_toio()") at least for
> little-endian kernels and should be fine now on ARM just like
> everywhere else.

Indeed, I had just previously checked it in 4.0 kernel and missed those
recent further optimizations. It should be fine to replace memcpy()
with memcpy_fromio() then.

--
Thanks,
Sylwester
