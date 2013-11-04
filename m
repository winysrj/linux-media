Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3KDOZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:25:10 -0500
Date: Mon, 4 Nov 2013 12:24:59 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCHv2 19/29] tuners: Don't use dynamic static allocation
Message-ID: <20131104122459.249609a5@infradead.org>
In-Reply-To: <5277A089.9060406@xs4all.nl>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
	<1383399097-11615-20-git-send-email-m.chehab@samsung.com>
	<5275357F.5090405@xs4all.nl>
	<20131102191515.0af09112@samsung.com>
	<52757474.8010303@xs4all.nl>
	<527575A8.2010906@xs4all.nl>
	<20131102222132.4fae86c2@samsung.com>
	<20131103071207.5b4060df@concha.lan>
	<5277A089.9060406@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 04 Nov 2013 14:26:33 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 11/03/2013 10:12 AM, Mauro Carvalho Chehab wrote:
> > Em Sat, 2 Nov 2013 22:21:32 -0200
> > Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> > 
> >> Em Sat, 02 Nov 2013 22:59:04 +0100
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>
> >>> On 11/02/2013 10:53 PM, Hans Verkuil wrote:
> >>>> On 11/02/2013 10:15 PM, Mauro Carvalho Chehab wrote:
> >>>>> Em Sat, 02 Nov 2013 18:25:19 +0100
> >>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>>>
> >>>>>> Hi Mauro,
> >>>>>>
> >>>>>> I'll review this series more carefully on Monday,
> >>>>>
> >>>>> Thanks!
> >>>>>
> >>>>>> but for now I want to make
> >>>>>> a suggestion for the array checks:
> >>>>>>
> >>>>>> On 11/02/2013 02:31 PM, Mauro Carvalho Chehab wrote:
> >>>>>>> Dynamic static allocation is evil, as Kernel stack is too low, and
> >>>>>>> compilation complains about it on some archs:
> >>>>>>>
> >>>>>>> 	drivers/media/tuners/e4000.c:50:1: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/e4000.c:83:1: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/fc2580.c:66:1: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/fc2580.c:98:1: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/tda18212.c:57:1: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/tda18212.c:90:1: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/tda18218.c:60:1: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]
> >>>>>>> 	drivers/media/tuners/tda18218.c:92:1: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
> >>>>>>>
> >>>>>>> Instead, let's enforce a limit for the buffer. Considering that I2C
> >>>>>>> transfers are generally limited, and that devices used on USB has a
> >>>>>>> max data length of 80, it seem safe to use 80 as the hard limit for all
> >>>>>>> those devices. On most cases, the limit is a way lower than that, but
> >>>>>>> 80 is small enough to not affect the Kernel stack, and it is a no brain
> >>>>>>> limit, as using smaller ones would require to either carefully each
> >>>>>>> driver or to take a look on each datasheet.
> >>>>>>>
> >>>>>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >>>>>>> Cc: Antti Palosaari <crope@iki.fi>
> >>>>>>> ---
> >>>>>>>  drivers/media/tuners/e4000.c    | 18 ++++++++++++++++--
> >>>>>>>  drivers/media/tuners/fc2580.c   | 18 ++++++++++++++++--
> >>>>>>>  drivers/media/tuners/tda18212.c | 18 ++++++++++++++++--
> >>>>>>>  drivers/media/tuners/tda18218.c | 18 ++++++++++++++++--
> >>>>>>>  4 files changed, 64 insertions(+), 8 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> >>>>>>> index ad9309da4a91..235e90251609 100644
> >>>>>>> --- a/drivers/media/tuners/e4000.c
> >>>>>>> +++ b/drivers/media/tuners/e4000.c
> >>>>>>> @@ -24,7 +24,7 @@
> >>>>>>>  static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
> >>>>>>>  {
> >>>>>>>  	int ret;
> >>>>>>> -	u8 buf[1 + len];
> >>>>>>> +	u8 buf[80];
> >>>>>>>  	struct i2c_msg msg[1] = {
> >>>>>>>  		{
> >>>>>>>  			.addr = priv->cfg->i2c_addr,
> >>>>>>> @@ -34,6 +34,13 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
> >>>>>>>  		}
> >>>>>>>  	};
> >>>>>>>  
> >>>>>>> +	if (1 + len > sizeof(buf)) {
> >>>>>>> +		dev_warn(&priv->i2c->dev,
> >>>>>>> +			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
> >>>>>>> +			 KBUILD_MODNAME, reg, len);
> >>>>>>> +		return -EREMOTEIO;
> >>>>>>> +	}
> >>>>>>> +
> >>>>>>
> >>>>>> I think this can be greatly simplified to:
> >>>>>>
> >>>>>> 	if (WARN_ON(len + 1 > sizeof(buf))
> >>>>>> 		return -EREMOTEIO;
> >>>>>>
> >>>>>> This should really never happen, and it is a clear driver bug if it does. WARN_ON
> >>>>>> does the job IMHO.
> >>>>>
> >>>>> Works for me. I'll wait for more comments, and go for it on v3.
> >>>>>
> >>>>>>  I also don't like the EREMOTEIO error: it has nothing to do with
> >>>>>> an I/O problem. Wouldn't EMSGSIZE be much better here?
> >>>>>
> >>>>>
> >>>>> EMSGSIZE is not used yet at drivers/media. So, it is probably not the
> >>>>> right error code.
> >>>>>
> >>>>> I remember that there's an error code for that on I2C (EOPNOTSUPP?).
> >>>>>
> >>>>> In any case, I don't think we should use an unusual error code here.
> >>>>> In theory, this error should never happen, but we don't want to break
> >>>>> userspace because of it. That's why I opted to use EREMOTEIO: this is
> >>>>> the error code that most of those drivers return when something gets
> >>>>> wrong during I2C transfers.
> >>>>
> >>>> The problem I have is that EREMOTEIO is used when the i2c transfer fails,
> >>>> i.e. there is some sort of a hardware or communication problem.
> >>>>
> >>>> That's not the case here, it's an argument error. So EINVAL would actually
> >>>> be better, but that's perhaps overused which is why I suggested EMSGSIZE.
> >>>> I personally don't think EIO or EREMOTEIO should be used for something that
> >>>> is not hardware related. I'm sure there are some gray areas, but this
> >>>> particular situation is clearly not hardware-related.
> >>>>
> >>>> So if EMSGSIZE won't work for you, then I prefer EINVAL over EREMOTEIO.
> >>>> ENOMEM is also an option (you are after all 'out of buffer memory').
> >>>> A bit more exotic, but still sort of in the area, is EPROTO.
> >>>
> >>> After thinking about it a little bit more I would just return -EINVAL. It's
> >>> a wrong argument, it's something that shouldn't happen at all, and you get a
> >>> big fat stack trace anyway due to the WARN_ON, so EINVAL makes perfect sense.
> >>
> >> Works for me.
> > 
> > After thinking a little bit about that, I think that using WARN_ON is not
> > a good idea.
> > 
> > The thing is that userspace may access directly the I2C devices, via 
> > i2c-dev, and try to read/write using more data than supported. On such cases,
> > the expected behavior is for the driver to return EOPNOTSUPP without generating
> > a WARN_ON dump.
> 
> Fair enough. I hadn't thought of that.
> 
> > So, IMHO, the better is to keep the patches as-is, and just replace the
> > return code to EOPNOTSUPP, if the size is bigger than supported.
> 
> I still think that EINVAL is the right error code here.

Ok. So, I'll use EINVAL for i2c client drivers, and EOPNOTSUPP on bridge
ones.

> I also wonder whether you really should print anything if this happens. Looking at
> the patch series it adds many such warnings in lots of drivers. I see this as an
> exceedingly rare thing, and just returning an error should be sufficient.

Well, eventually, we might be putting a lower limit than needed. As this
printk is rare enough, and it will help a lot on debugging issues at the
driver if it ever happens, I think that the better is to add a printk
here.
 
> In the case of i2c-dev I don't think you want to print anything anyway if the user
> provides too much data: it's generally not a good idea to print warnings in the kernel
> log in case of incorrect user input.

Agreed, but we can't distinguish if it happened due to i2c-dev or due to a
bridge call. So, I think that having a single printk line (as opposite to
a WARN_ON dump) to be a good compromise.

Regards,
Mauro
