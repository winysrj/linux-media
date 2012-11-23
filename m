Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59693 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2KWSL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 13:11:59 -0500
Date: Fri, 23 Nov 2012 19:12:32 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
Message-ID: <20121123191232.7ed9c546@armhf>
In-Reply-To: <20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
References: <20121122124652.3a832e33@armhf>
	<20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Nov 2012 18:09:09 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> On Thu, 22 Nov 2012 12:46:52 +0100
	[snip]
> Jean-Francois Moine <moinejf@free.fr> wrote:
> > This patch was done thanks to the documentation of the right
> > OmniVision sensors.
> 
> In the datasheet I have for ov772x, bit[6] of register 0x13 is described
> as:
> 
>   Bit[6]: AEC - Step size limit
>     0: Step size is limited to vertical blank
>     1: Unlimited step size

Right, but I don't use the bit 6, it is the bit 5:

> > +		sccb_reg_write(gspca_dev, 0x13,		/* auto */
> > +				sccb_reg_read(gspca_dev, 0x13) | 0x20);

which is described as:

   Bit[5]:  Banding filter ON/OFF

> And the patch makes Light Frequency _NOT_ work with the PS3 eye (based
> on ov772x).
> 
> What does the ov767x datasheet say?

Quite the same thing:

   Bit[5]: Banding filter ON/OFF - In order to turn ON the banding
           filter, BD50ST (0x9D) or BD60ST (0x9E) must be set to a
           non-zero value.
           0: OFF
           1: ON

(the registers 9d and 9e are non zero for the ov767x in ov534.c)

> Maybe we should use the new values only when
> 	sd->sensor == SENSOR_OV767x
> 
> What sensor does Alexander's webcam use?

He has exactly the same webcam as yours: 1415:2000 (ps eye) with
sensor ov772x.

> > Note: The light frequency filter is either off or automatic.
> > The application will see either off or "50Hz" only.
> > 
> > Tested-by: alexander calderon <fabianp902@gmail.com>
> > Signed-off-by: Jean-François Moine <moinejf@free.fr>
> > 
> > --- a/drivers/media/usb/gspca/ov534.c
> > +++ b/drivers/media/usb/gspca/ov534.c
> > @@ -1038,13 +1038,12 @@
> >  {
> >  	struct sd *sd = (struct sd *) gspca_dev;
> > 
> 
> drivers/media/usb/gspca/ov534.c: In function ‘setlightfreq’:
> drivers/media/usb/gspca/ov534.c:1039:13: warning: unused variable ‘sd’ [-Wunused-variable]

Thanks.

Well, here is one of the last message I received from Alexander (in
fact, his first name is Fabian):

> Thanks for all your help, it is very kind of you, I used the code below,the
> 60 Hz filter appear to work even at 100fps, but when I used 125 fps it
> didnt work :( , i guess it is something of detection speed. If you have any
> other idea I'll be very thankful.
> 
> Sincerely Fabian Calderon

So, how may we advance?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
