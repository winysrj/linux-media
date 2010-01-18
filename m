Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.vodamail.co.za ([196.11.146.226]:39828 "EHLO
	vodamail.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751327Ab0ARTnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 14:43:07 -0500
Subject: Re: [PATCH] Compro S350 GPIO change
From: JD Louw <jd.louw@mweb.co.za>
To: Theunis Potgieter <theunis.potgieter@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <23582ca1001172352k21d5ceua2067b7eba020369@mail.gmail.com>
References: <1263733066.2031.15.camel@Core2Duo>
	 <23582ca1001172352k21d5ceua2067b7eba020369@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 21:42:50 +0200
Message-ID: <1263843770.3042.11.camel@Core2Duo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-01-18 at 09:52 +0200, Theunis Potgieter wrote:
> 2010/1/17 JD Louw <jd.louw@mweb.co.za>:
> > Hi,
> >
> > This patch enables LNB power on newer revision d1 Compro S350 and S300
> > DVB-S cards. While I don't have these cards to test with I'm confident
> > that this works. See
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/7471 and http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/14296
> > and new windows driver as reference.
> >
> > Signed-off-by: JD Louw <jd.louw@mweb.co.za>
> >
> > diff -r 59e746a1c5d1 linux/drivers/media/video/saa7134/saa7134-cards.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Wed Dec 30
> > 09:10:33 2009 -0200
> > +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Jan 17
> > 14:51:07 2010 +0200
> > @@ -7037,8 +7037,8 @@ int saa7134_board_init1(struct saa7134_d
> >                break;
> >        case SAA7134_BOARD_VIDEOMATE_S350:
> >                dev->has_remote = SAA7134_REMOTE_GPIO;
> > -               saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
> > -               saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> > +               saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
> > +               saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000C000, 0x0000C000);
> >                break;
> >        }
> >        return 0;
> >
> >
> > --
> Hi Jan,
> 
> This does not fix the problem where the card is suppose to suspend and
> the Voltage drops to 0V? Do you still require the windows registry
> reference for this part?

Hi,

No, the aim of the patch is just to get the basic driver support for all
S300/S350 revisions. A windows regspy capture on a d1 revision card may
still be useful in double checking the GPIO values, but I already know
which GPIO controls LNB voltage:

GPIO15 = modulator reset
GPIO14 = LNB power


