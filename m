Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51759 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3HaLPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 07:15:30 -0400
Received: by mail-we0-f171.google.com with SMTP id p57so2393972wes.30
        for <linux-media@vger.kernel.org>; Sat, 31 Aug 2013 04:15:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5220CADF.5050805@licor.com>
References: <5220CADF.5050805@licor.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 31 Aug 2013 16:45:08 +0530
Message-ID: <CA+V-a8t7sb9HVACCVTDG0c2LH6Ca=Tc7EY=UmU38apKNjVdZyA@mail.gmail.com>
Subject: Re: davinci vpif_capture
To: Darryl <ddegraff@licor.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 30, 2013 at 10:09 PM, Darryl <ddegraff@licor.com> wrote:
> I am working on an application involving the davinci using the vpif.  My
> board file has the inputs configured to use VPIF_IF_RAW_BAYER if_type.
> When my application starts up, I have it enumerate the formats
> (VIDIOC_ENUM_FMT) and it indicates that the only available format is
> "YCbCr4:2:2 YC Planar" (from vpif_enum_fmt_vid_cap).  It looks to me that
> the culprit is vpif_open().
>
> struct channel_obj.vpifparams.iface is initialized at vpif_probe() time in
> the function vpif_set_input.  Open the device file (/dev/video0) overwrites
> this.  I suspect that it is __not__ supposed to do this, since I don't see
> any method for restoring the iface.
>
NAK, Ideally the application should go in the following manner,
you open the device say example /dev/video0 , then you issue
a VIDIOC_ENUMINPUT IOCTL,  this will enumerate the inputs
then you do  VIDIOC_S_INPUT this will select the input device
so when this IOCTL is called vpif_s_input() is called in vpif_capture
driver this function will internally call the vpif_set_input() which
will set the iface for you on line 1327.

In the probe it calls vpif_set_input() to select input 0 as a default device.

Hope this clears your doubt.

Regards,
--Prabhakar Lad

> I'm using linux-3.10.4, but the problem appears in 3.10.9, 3.11.rc7 and a
> version I checked out at
> https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git. I
> have supplied a patch for 3.10.9.
>
>
> diff -pubwr
> linux-3.10.9-pristine/drivers/media/platform/davinci/vpif_capture.c
> linux-3.10.9/drivers/media/platform/davinci/vpif_capture.c
> --- linux-3.10.9-pristine/drivers/media/platform/davinci/vpif_capture.c
> 2013-08-20 17:40:47.000000000 -0500
> +++ linux-3.10.9/drivers/media/platform/davinci/vpif_capture.c  2013-08-30
> 11:18:29.000000000 -0500
> @@ -914,9 +914,11 @@ static int vpif_open(struct file *filep)
>      fh->initialized = 0;
>      /* If decoder is not initialized. initialize it */
>      if (!ch->initialized) {
> +        struct vpif_interface iface = ch->vpifparams.iface;
>          fh->initialized = 1;
>          ch->initialized = 1;
>          memset(&(ch->vpifparams), 0, sizeof(struct vpif_params));
> +        ch->vpifparams.iface = iface;
>      }
>      /* Increment channel usrs counter */
>      ch->usrs++;
>
>
>
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
