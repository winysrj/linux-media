Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42810 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaJaQhc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 12:37:32 -0400
Date: Fri, 31 Oct 2014 14:37:27 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx231xx: remove direct register PWR_CTL_EN modification
 that switches port3
Message-ID: <20141031143727.7ea39e30@recife.lan>
In-Reply-To: <54538A26.70901@gentoo.org>
References: <20141030182706.09265d37@recife.lan>
	<1414709035-7729-1-git-send-email-zzam@gentoo.org>
	<20141031083258.4cfd463a@recife.lan>
	<54538A26.70901@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 31 Oct 2014 14:09:58 +0100
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> On 31.10.2014 11:32, Mauro Carvalho Chehab wrote:
> > Em Thu, 30 Oct 2014 23:43:55 +0100
> > Matthias Schwarzott <zzam@gentoo.org> escreveu:
> > 
> >> The only remaining place that modifies the relevant bit is in function
> >> cx231xx_set_Colibri_For_LowIF
> >>
> >> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> >> ---
> >>  drivers/media/usb/cx231xx/cx231xx-avcore.c | 3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> >> index b56bc87..781908b 100644
> >> --- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
> >> +++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> >> @@ -2270,7 +2270,6 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
> >>  	case POLARIS_AVMODE_ANALOGT_TV:
> >>  
> >>  		tmp |= PWR_DEMOD_EN;
> >> -		tmp |= (I2C_DEMOD_EN);
> >>  		value[0] = (u8) tmp;
> >>  		value[1] = (u8) (tmp >> 8);
> >>  		value[2] = (u8) (tmp >> 16);
> >> @@ -2366,7 +2365,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
> >>  		}
> >>  
> >>  		tmp &= (~PWR_AV_MODE);
> >> -		tmp |= POLARIS_AVMODE_DIGITAL | I2C_DEMOD_EN;
> >> +		tmp |= POLARIS_AVMODE_DIGITAL;
> >>  		value[0] = (u8) tmp;
> >>  		value[1] = (u8) (tmp >> 8);
> >>  		value[2] = (u8) (tmp >> 16);
> > 
> 
> Hi Mauro,
> 
> > Hmm... Not sure if this patch is right. There is one I2C bus internally
> > at cx231xx. Some configurations need to go through this I2C bus. 
> > 
> 
> What exactly do you mean by configurations need to go through this I2C
> bus? Do you mean the port3 switch must have a specific value even when
> not doing i2c transfers?

No, I think I miss expressed... What I meant to say is that, on Colibri
(e. g. cx231xx), internal I2C buses are used to control some IP parts of
the chip design. Maybe setting I2C_DEMOD_EN there is a requirement for
those commands to go to the right IP block.

> 
> > Did you test if changing from/to analog/digital mode is working?
> > 
> 
> I did not yet check analog mode.

Ok. I'll add analog to my test plan.

> 
> Regards
> Matthias
> 
