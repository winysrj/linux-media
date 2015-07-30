Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34268 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbG3Lhn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 07:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAOcJUbw5hSmPdrz6rPPYU6iMBHnvOZc1p3f+4WhEYq2-XmAPVw@mail.gmail.com>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
	<1435158670-7195-3-git-send-email-peter.griffin@linaro.org>
	<1435195057.9377.18.camel@perches.com>
	<20150722185811.2d718baa@recife.lan>
	<20150730094738.GD488@griffinp-ThinkPad-X1-Carbon-2nd>
	<1438250928.2677.10.camel@perches.com>
	<CAOcJUbw5hSmPdrz6rPPYU6iMBHnvOZc1p3f+4WhEYq2-XmAPVw@mail.gmail.com>
Date: Thu, 30 Jul 2015 07:37:41 -0400
Message-ID: <CAOcJUbwVBVxmaP-vNkw0n8Cf3-=Fn8Aou8FG81Ajab1B2h4Z4A@mail.gmail.com>
Subject: Re: [PATCH 02/12] [media] dvb-pll: Add support for THOMSON DTT7546X tuner.
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	LKML <linux-kernel@vger.kernel.org>,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media <linux-media@vger.kernel.org>,
	devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 30, 2015 at 7:14 AM, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
> On Thu, Jul 30, 2015 at 6:08 AM, Joe Perches <joe@perches.com> wrote:
>> On Thu, 2015-07-30 at 10:47 +0100, Peter Griffin wrote:
>>> Hi Mauro / Joe,
>>>
>>> On Wed, 22 Jul 2015, Mauro Carvalho Chehab wrote:
>>>
>>> > Em Wed, 24 Jun 2015 18:17:37 -0700
>>> > Joe Perches <joe@perches.com> escreveu:
>>> >
>>> > > On Wed, 2015-06-24 at 16:11 +0100, Peter Griffin wrote:
>>> > > > This is used in conjunction with the STV0367 demodulator on
>>> > > > the STV0367-NIM-V1.0 NIM card which can be used with the STi
>>> > > > STB SoC's.
>>> > >
>>> > > Barely associated to this specific patch, but for
>>> > > dvb-pll.c, another thing that seems possible is to
>>> > > convert the struct dvb_pll_desc uses to const and
>>> > > change the "entries" fixed array size from 12 to []
>>> > >
>>> > > It'd save a couple KB overall and remove ~5KB of data.
>>> > >
>>> > > $ size drivers/media/dvb-frontends/dvb-pll.o*
>>> > >    text      data     bss     dec     hex filename
>>> > >    8520      1552    2120   12192    2fa0 drivers/media/dvb-frontends/dvb-pll.o.new
>>> > >    5624      6363    2120   14107    371b drivers/media/dvb-frontends/dvb-pll.o.old
>>> >
>>> > Peter,
>>> >
>>> > Please add this patch on the next patch series you submit.
>>>
>>> Ok will do, I've added this patch with a slightly updated commit message
>>> to my series.
>>>
>>> Joe - Can I add your signed-off-by?
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> Reviewed-by: Michael Ira Krufky <m.krufky@samsung.com>
>
> Joe, nice optimization - thanks for that.
>
> With regards to Peter's patch, is this a digital-only tuner, or is it
> a hybrid tuner?
>
> The 5th byte that you send to the THOMSON DTT7546X seems to resemble
> the 'auxiliary byte' that gets set in tuner-simple.c
>
> I'm not sure that dvb-pll is the right place for this tuner
> definition, if this is the case.  Maybe this definition belongs in
> tuner-simple instead, if the pattern matches better there.
>
> Mauro, can we hold off on merging Peter's patch until we resolve this?

This code block, specifically, I would rather not see added into dvb-pll:

+static int dvb_pll_get_num_regs(struct dvb_pll_priv *priv)
+{
+       int num_regs = 4;
+
+       if (strncmp(priv->pll_desc->name, "Thomson dtt7546x", 16) == 0)
+               num_regs = 5;
+
+       return num_regs;
+}
+

tuner-simple provides an infrastructure that allows this tuner to be
added in a more elegant way without the need to add special cases to
otherwise generic code, as done in the above.

I'm sorry, Peter.  Can you take a look at tuner-simple and consider
sending a new patch?

-Michael Ira Krufky
