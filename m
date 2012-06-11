Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab2FKSPj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 14:15:39 -0400
Message-ID: <4FD635DB.2050705@redhat.com>
Date: Mon, 11 Jun 2012 20:15:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Bernard GODARD <bernard.godard@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: PWC ioctl inappropriate for device (Regression)
References: <CAFxvmmfFqCQg3QxirmPazdqNuBq6SxbezUR9T1bo+SRRL9-hBA@mail.gmail.com> <4FD3BB42.2010803@redhat.com> <CAFxvmmdUp8-JuPuL=wdZyPkUZ9NEPucwS6ZQf_M0CuWs_bZm+g@mail.gmail.com>
In-Reply-To: <CAFxvmmdUp8-JuPuL=wdZyPkUZ9NEPucwS6ZQf_M0CuWs_bZm+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/11/2012 04:34 PM, Bernard GODARD wrote:
> Hi Hans,
>
> Thank you for your reply.
>
> I will try to do the fix in qastrocam-g2 myself as this program does
> not currently have a maintainer.

Thanks! Please let me know if you need any help.

If programs like qastrocam-g2 are going to depend on some of the
custom v4l2 ctrls pwc has (so controls not using a standard ctrl id),
then one of the first steps would be to make the ctrl ids for all the
custom controls available in a public header file.

Which means writing a (simple) kernel patch, currently
drivers/media/video/pwc/pwc-v4l.c in the kernel has:

#define PWC_CID_CUSTOM(ctrl) ((V4L2_CID_USER_BASE | 0xf000) + custom_ ## ctrl)

and:

enum { custom_autocontour, custom_contour, custom_noise_reduction,
         custom_awb_speed, custom_awb_delay,
         custom_save_user, custom_restore_user, custom_restore_factory };

And then in various places uses things like:

PWC_CID_CUSTOM(autocontour)

I think it would be best to make a new include/media/pwc.h file, which
then would contain things like:

PWC_CID_AUTOCONTOUR (V4L2_CID_USER_BASE | 0xf000)
PWC_CID_CONTOUR     (V4L2_CID_USER_BASE | 0xf001)

And then in drivers/media/video/pwc/pwc-v4l.c replace PWC_CID_CUSTOM(autocontour)
with PWC_CID_AUTOCONTOUR, etc. It would be good to keep the order the same, as
in the enum, this way your modified qastrocam-g2 will work with the current
kernel too, as the ids are then unchanged.

Another something to look at is the V4L2_CID_AUTO_WHITE_BALANCE control,
which uses a menu, rather then being the standard boolean. The very latest
kernel code has a new standardized ctrl for auto-whitebalance controls
which are a menu, see:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=e40a05736d4503950ec303610a51f838bd59cdc1

It would be nice if you could do a patch to move pwc over to this too. Note
that pwc will move over to this sooner or later (probably sooner, so if you
don't feel up to doing a patch for this yourself let me know and I'll do one),
as making qastrocam-g2 work only with the current V4L2_CID_AUTO_WHITE_BALANCE
and not with the future V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE control means
it will break again in the future :/

This does mean that if you want the modified qastrocam-g2 to work both with
current kernels and with newer kernels where pwc has moved over to
V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE, you need to support both. You can simply
do a VIDIOC_QUERYCTRL on both to see which one is present to support both.

Regards,

Hans
