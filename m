Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab1JESil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 14:38:41 -0400
Received: by bkbzt4 with SMTP id zt4so2476195bkb.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 11:38:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANut7vBzVpOdqKHxWeZbV1r+9cfBJ3r01i6LKFCoTCTeu55Zpg@mail.gmail.com>
References: <CANut7vBzVpOdqKHxWeZbV1r+9cfBJ3r01i6LKFCoTCTeu55Zpg@mail.gmail.com>
Date: Wed, 5 Oct 2011 14:38:40 -0400
Message-ID: <CAGoCfiyNekcUPM_pCn2Y0mf3tMMd=1nWJveP8DBibd53nZ7vJA@mail.gmail.com>
Subject: Re: fm player for v4l2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Will Milspec <will.milspec@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 5, 2011 at 2:32 PM, Will Milspec <will.milspec@gmail.com> wrote:
> hi all,
>
> After recent-ish kernel updates, "fmtools" no longer works.  (I'm
> running gentoo currently on kernel 3.0.6)
>
> I believe the changes pertain to V4L1 vs L2 api changes. I am not a
> linux developer, however, and can't speak w/ authority.
>
> I've appended my v4l-info at the end of this email
>
> Example Failing Command
> ==================
> $fm 91.5
> ioctl VIDIOCGAUDIO: Invalid argument
>
> Kernel V4L options
> ==================
> Here's my kernel configuration:
>
> CONFIG_VIDEO_V4L2_COMMON=y
> CONFIG_VIDEO_V4L2=y
> CONFIG_V4L_USB_DRIVERS=y
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
>
>
> Can anyone recommend:
> - any fm software that works w/ V4L2?
> - any kernel tweaks I can make to keep the old fmtools app working?
> - any other "next steps"

Unfortunately, despite V4L1 having been deprecated almost a decade
ago, essentially every application out there was still depending on it
at the source code level.  Once the kernel finally dropped the support
entirely, changes were required to MythTV, tvtime, xawtv, for them to
start working again (pretty much every project I know of went "oh
crap" when it disappeared).

Somebody will probably have to "fix" the fmtools source code to no
longer depend on V4L1.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
