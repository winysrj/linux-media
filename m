Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33410 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbcGIOsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 10:48:46 -0400
Received: by mail-lf0-f41.google.com with SMTP id f6so44472102lfg.0
        for <linux-media@vger.kernel.org>; Sat, 09 Jul 2016 07:48:45 -0700 (PDT)
Date: Sat, 9 Jul 2016 17:48:10 +0300
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey_utkin@fastmail.com>
Subject: Re: [PATCH v2] Add tw5864 driver
Message-ID: <20160709144810.GA15909@acer>
References: <20160609221142.10139-1-andrey.utkin@corp.bluecherry.net>
 <0166f7df-2d34-f937-5cc0-0596fc14c5b1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0166f7df-2d34-f937-5cc0-0596fc14c5b1@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for great help.
I believe the issues highlighted by your are rectified by now.

One chunk of your proposed changes seems to be wrong.

Also I have one non-technical change I want to introduce to this driver, see it
in the bottom of this letter ("Also, I decided to document known video quality
issues in a printed warning...").

On Fri, Jul 01, 2016 at 03:35:40PM +0200, Hans Verkuil wrote:
> On 06/10/2016 12:11 AM, Andrey Utkin wrote:
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> This line can be dropped: the v4l2 core will do this automatically.

This seems not so: dropping it resulted in new compliance fails:

Required ioctls:
        fail: v4l2-compliance.cpp(550): dcaps & ~caps
    test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
    test second video open: OK
        fail: v4l2-compliance.cpp(550): dcaps & ~caps
    test VIDIOC_QUERYCAP: FAIL


I am running latest v4l-utils from git.
This particular fail happens on kernels built from next-20160707 and
next-20160609.

BTW next-20160707 makes my dev machine to hang after few minutes of uptime,
regardless of my module being loaded, so for now I am testing driver on
next-20160609.
This (running old linux-next) causes such new fail with latest v4l-utils:

fail: v4l2-test-buffers.cpp(293): g_flags() & V4L2_BUF_FLAG_DONE

which is understandable because of recent commit to v4l-utils flipping expected
behaviour in this regard:

commit 7d784c6894b10cdf5ec025c2cd7c320320f5f658
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Fri Jul 8 23:10:34 2016 +0200

    v4l2-compliance: fix a check for the DONE flag
    
    This was always set by vb2 drivers due to a bug. It is now cleared
    again after that bug was fixed, but the test should now be inverted.
    
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index fb14170..dc82918 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -290,7 +290,7 @@ int buffer::check(unsigned type, unsigned memory, unsigned index,
                        fail_on_test(g_bytesused(p) > g_length(p));
                }
                fail_on_test(!g_timestamp().tv_sec && !g_timestamp().tv_usec);
-               fail_on_test(!(g_flags() & V4L2_BUF_FLAG_DONE));
+               fail_on_test(g_flags() & V4L2_BUF_FLAG_DONE);
                fail_on_test((int)g_sequence() < seq.last_seq + 1);
                if (v4l_type_is_video(g_type())) {
                        fail_on_test(g_field() == V4L2_FIELD_ALTERNATE);

So please expect this fail in v4l2-compliance logs of my new submission.



Also, I decided to document known video quality issues in a printed warning; I
like how it looks now both in code and in dmesg, but checkpatch.pl doesn't like
it. See commit at
https://github.com/bluecherrydvr/linux/commit/83395b6c5e1e5ceb642c9a04a28db5fc22566c87

The message is split in pieces because otherwise it gets truncated.

I'd like some approval or suggestion for rework on this.

It looks like this in dmesg:

[ 5101.182151] tw5864 0000:06:07.0: BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY

               This driver was developed by Bluecherry LLC by deducing behaviour of original manufacturer's driver, from both source code and execution traces.
               It is known that there are some artifacts on output video with this driver:
                - on all known hardware samples: random pixels of wrong color (mostly white, red or blue) appearing and disappearing on sequences of P-frames;
                - on some hardware samples (known with H.264 core version e006:2800): total madness on P-frames: blocks of wrong luminance; blocks of wrong colors "creeping" across the picture.
               There is a workaround for both issues: avoid P-frames by setting GOP size to 1. To do that, run such command on device files created by this driver:

               for dev in /dev/video*; do v4l2-ctl --device $dev --set-ctrl=video_gop_size=1; done

[ 5101.357312] systemd-journald[219]: Compressed data object 850 -> 636 using XZ
[ 5101.471071] tw5864 0000:06:07.0: These issues are not decoding errors; all produced H.264 streams are decoded properly. Streams without P-frames don't have these artifacts so it's not analog-to-digital conversion issues nor internal memory errors; we conclude it's internal H.264 encoder issues.
               We cannot even check the original driver's behaviour because it has never worked properly at all in our development environment. So these issues may be actually related to firmware or hardware. However it may be that there's just some more register settings missing in the driver which would please the hardware.
               Manufacturer didn't help much on our inquiries, but feel free to disturb again the support of Intersil (owner of former Techwell).


And checkpatch says this:

 $ ./../../../../scripts/checkpatch.pl -f tw5864-core.c
WARNING: quoted string split across lines
#44: FILE: tw5864-core.c:44:
+"This driver was developed by Bluecherry LLC by deducing behaviour of original"
+" manufacturer's driver, from both source code and execution traces.\n"

WARNING: quoted string split across lines
#47: FILE: tw5864-core.c:47:
+" - on all known hardware samples: random pixels of wrong color (mostly white,"
+" red or blue) appearing and disappearing on sequences of P-frames;\n"

WARNING: quoted string split across lines
#49: FILE: tw5864-core.c:49:
+" - on some hardware samples (known with H.264 core version e006:2800):"
+" total madness on P-frames: blocks of wrong luminance; blocks of wrong colors"

WARNING: quoted string split across lines
#50: FILE: tw5864-core.c:50:
+" total madness on P-frames: blocks of wrong luminance; blocks of wrong colors"
+" \"creeping\" across the picture.\n"

WARNING: quoted string split across lines
#52: FILE: tw5864-core.c:52:
+"There is a workaround for both issues: avoid P-frames by setting GOP size to 1"
+". To do that, run such command on device files created by this driver:\n"

WARNING: quoted string split across lines
#55: FILE: tw5864-core.c:55:
+"for dev in /dev/video*; do"
+" v4l2-ctl --device $dev --set-ctrl=video_gop_size=1; done\n"

WARNING: quoted string split across lines
#59: FILE: tw5864-core.c:59:
+static char *artifacts_warning_continued = ""
+"These issues are not decoding errors; all produced H.264 streams are decoded"

WARNING: quoted string split across lines
#60: FILE: tw5864-core.c:60:
+"These issues are not decoding errors; all produced H.264 streams are decoded"
+" properly. Streams without P-frames don't have these artifacts so it's not"

WARNING: quoted string split across lines
#61: FILE: tw5864-core.c:61:
+" properly. Streams without P-frames don't have these artifacts so it's not"
+" analog-to-digital conversion issues nor internal memory errors; we conclude"

WARNING: quoted string split across lines
#62: FILE: tw5864-core.c:62:
+" analog-to-digital conversion issues nor internal memory errors; we conclude"
+" it's internal H.264 encoder issues.\n"

WARNING: quoted string split across lines
#64: FILE: tw5864-core.c:64:
+"We cannot even check the original driver's behaviour because it has never"
+" worked properly at all in our development environment. So these issues may be"

WARNING: quoted string split across lines
#65: FILE: tw5864-core.c:65:
+" worked properly at all in our development environment. So these issues may be"
+" actually related to firmware or hardware. However it may be that there's just"

WARNING: quoted string split across lines
#66: FILE: tw5864-core.c:66:
+" actually related to firmware or hardware. However it may be that there's just"
+" some more register settings missing in the driver which would please the"

WARNING: quoted string split across lines
#67: FILE: tw5864-core.c:67:
+" some more register settings missing in the driver which would please the"
+" hardware.\n"

WARNING: quoted string split across lines
#69: FILE: tw5864-core.c:69:
+"Manufacturer didn't help much on our inquiries, but feel free to disturb again"
+" the support of Intersil (owner of former Techwell).\n"

total: 0 errors, 15 warnings, 377 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

tw5864-core.c has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.
