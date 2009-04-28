Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:33699 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbZD1AOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 20:14:55 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Andy Walls <awalls@radix.net>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
In-Reply-To: <20090427192905.3ad2b88c@glory.loctelecom.ru>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	 <1240452534.3232.70.camel@palomino.walls.org>
	 <20090423203618.4ac2bc6f@glory.loctelecom.ru>
	 <1240537394.3231.37.camel@palomino.walls.org>
	 <20090427192905.3ad2b88c@glory.loctelecom.ru>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 02:11:42 +0200
Message-Id: <1240877502.13282.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 27.04.2009, 19:29 +1000 schrieb Dmitri Belimov:
> Hi All
> 
> Step by step.
> 
> This is patch for change only range of FM1216ME_MK3. Slow tunning is not a big problem.
> 
> diff -r b40d628f830d linux/drivers/media/common/tuners/tuner-types.c
> --- a/linux/drivers/media/common/tuners/tuner-types.c	Fri Apr 24 01:46:41 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue Apr 28 03:35:42 2009 +1000
> @@ -558,8 +558,8 @@
>  
>  static struct tuner_range tuner_fm1216me_mk3_pal_ranges[] = {
>  	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
> -	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> -	{ 16 * 999.99        , 0x8e, 0x04, },
> +	{ 16 * 441.00 /*MHz*/, 0x8e, 0x02, },
> +	{ 16 * 864.00        , 0x8e, 0x04, },
>  };
>  
>  static struct tuner_params tuner_fm1216me_mk3_params[] = {
> 
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

if it does help anything for having all above 441 MHz in UHF ranges.

Acked-by: Hermann Pitton <hermann-pitton@arcor.de>

There is simply no known broadcast in that gap on other freq. tables.

Can you please enlighten us who/what broadcasts there?

> 
> With my best regards, Dmitry.
> 
> > Hi Dmitri,

Cheers,
Hermann

> > Thank you for you responses.
> > 
> > Just a few more comments...
> > 
> > On Thu, 2009-04-23 at 20:36 +1000, Dmitri Belimov wrote:
> > > Hi Andy
> > > 
> > > > Dmitri,
> > > > 
> > > > 
> > > > On Wed, 2009-04-22 at 17:48 +1000, Dmitri Belimov wrote:
> > > > > Hi All
> > > > > 
> > > > > 1. Change middle band. In the end of the middle band the
> > > > > sensitivity of receiver not good. If we switch to higher band,
> > > > > sensitivity more better. Hardware trick.
> > > > 
> > 
> > > Several years a go your customers write some messages about bad
> > > quality of TV if frequency of TV is the end of band. It can be low
> > > band or middle. Our hardware engeneer make some tests with hardware
> > > TV generator and our TV tuners.
> > > 
> > > If we set default frequency range for low and middle band, quality
> > > of TV signal on 159MHz and 442 MHz is bad. When we make our changes
> > > with moving end of bands the quality of TV much better. And our
> > > system programmer for OS Windows use changed bands for drivers.
> > > Customers be happy.
> > 
> > OK.  A properly run experiment wins over theory every time. :)
> > 
> > 
> > 
> > > You can test it if in your placement available TV programm on
> > > 159MHz or 442MHz. This trick can be usefull for other tuners.
> > 
> > If you look at tveeprom.c, a number of other tuners are using that
> > tuner definition:
> > 
> > $ grep FM1216ME_MK3 tveeprom.c
> > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216ME MK3"},
> > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216 ME
> > MK3"}, { TUNER_PHILIPS_FM1216ME_MK3, 	"LG S001D MK3"},
> > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"LG S701D MK3"},
> > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216LME
> > MK3"}, { TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MFPE05 2"},
> > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MPE05-2"},
> > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216ME MK5"},
> > 
> > If your change makes things bad for the other tuners, we'll probably
> > have to create an alternate entry for the other tuners instead of
> > using the FM1216ME_MK3 defintion.  I suspect most of them are clones
> > of the FM1216ME MK3 however, so it probably won't matter.
> > 
> > > > > 3. Set charge pump bit
> > > > 
> > > > This will improve the time to initially tune to a frequency, but
> > > > will likely add some noise as the PLL continues to maintain lock
> > > > on the signal.  If there is no way to turn off the CP after the
> > > > lock bit is set in the tuner, it's probably better to leave it
> > > > off for lower noise and just live with slower tuning.
> > > 
> > > We discuss with our windows system programmer about it. He sad that
> > > in analog TV mode noise from PLL don't give any problem.
> > 
> > I would be concerned about phase noise affecting the colors or any FM
> > sound carriers.  If the noise isn't noticably affecting colors to the
> > human eye (do color bars look OK?), or sound to the human ear, then
> > OK.
> > 
> > 
> > >  But in digital TV mode
> > > noise from PLL decreased BER.
> > 
> > I thought the FM1216ME MK3 was an analog only tuner.  I guess I don't
> > know DVB-T or cable in Europe well enough.
> > 
> > 
> > > > Leaving the CP bit set should be especially noticable ad FM noise
> > > > when set to tune to FM radio stations.  From the FM1236ME_MK3
> > > > datasheet: "It is recommended to set CP=0 in the FM mode at all
> > > > times." But the VHF low band control byte is also used when
> > > > setting FM radio (AFAICT with a quick look at the code.)
> > > 
> > > Yes. You are right. We can swith CP off in FM mode.
> > 
> > OK.  Thank you.
> > 
> > > With my best regards, Dmitry.
> > 
> > 
> > Regards,
> > Andy
> > 
> > 
> > 

