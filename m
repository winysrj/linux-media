Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7L862PE002947
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 04:06:02 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7L85o2d031015
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 04:05:50 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
In-Reply-To: <48A8698E.3090004@hhs.nl>
References: <48A8698E.3090004@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 21 Aug 2008 09:49:38 +0200
Message-Id: <1219304978.1762.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: PATCH: gspca-spc200nc-upside-down-v2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 2008-08-17 at 20:10 +0200, Hans de Goede wrote:
> Hi,

Hi Hans,

> This patch adds a V4L2_CAP_SENSOR_UPSIDE_DOWN flag to the capabilities flags,
> and sets this flag for the Philips SPC200NC cam (which has its sensor installed
> upside down). The same flag is also needed and added for the Philips SPC300NC.
	[snip]
> Of you do not plan to apply this patch please let me know that and why, then we 
> can discuss this further, I really believe that in cases where the upside down 
> ness is 100% known at the kernel level we should report this in some way to 
> userspace so that libv4l can flip the image in software. I know that for 
> certain cases the upside down ness needs to be determined elsewhere, but not 
> for all cases.
> 
> I believe all hardware info for a certain piece of hardware should be kept at 
> one place, and in this case that is the driver. With upside down mounted 
> generic laptop cam modules, the upside down ness is not module specific but 
> laptop specific and thus this info should be stored in hal, which takes care of 
> laptop model specific things which can differ from laptop to laptop even though 
> they use the same lowlevel IC's. In this case however this is not system/latop 
> specific but cam specific so this info should be stored together with the other 
> cam specific knowledge (such as which sensor it uses) in the driver.

Well, I looked at various messages in various mail-lists talking about
upside down. Sometimes, a webcam may be normal or upside down, or even
just mirrored. Two times only (Vimicro 0325 and 0326), they say that the
webcam is always upside down. So, is it useful to make a generic code
for this specific case?

For the general case (the webcam may have H or V flip, or both - upside
down). The user will see it. If she may use the HFLIP and VFLIP
controls, she will get a correct image. To go further, it will be nice
to have a v4l2 control program which saves and restores the video
control values at system stop and start times, as it is done for sound.

BTW, if noticed a small difference in the PAS106B initialization between
the actual driver (zc3xx) and the data in usbvm31b.inf. As I have no
such webcams, may anybody check what happens changing the lines 4146 and
4264 of zc3xx.c from
	{0xa0, 0x00, 0x01ad},
to
	{0xa0, 0x09, 0x01ad},

This will impact on the webcams V:041e P:401c, 4034 and 4035, V:0471,
P:0325, 0326, 032d and 032e.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
