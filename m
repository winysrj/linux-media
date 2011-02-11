Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1BKRhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 12:37:19 -0500
Received: by fxm20 with SMTP id 20so2936356fxm.19
        for <linux-media@vger.kernel.org>; Fri, 11 Feb 2011 09:37:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110211135425.6441a750@pedra>
References: <20110211135425.6441a750@pedra>
Date: Fri, 11 Feb 2011 12:37:16 -0500
Message-ID: <AANLkTimWFVj-v3QOyTVhquQQKVy_PO+q3dkPmY6_UGJT@mail.gmail.com>
Subject: Re: [PATCH 0/8] Port xf86-video-v4l driver to V4L2 version 2
From: Alex Deucher <alexdeucher@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dmitry Butskoy <buc@odusz.so-cdu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Feb 11, 2011 at 10:54 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is the second version of my backport patches. To avoid spending
> people's time on looking at lines that have only whitespace changes,
> I broke the patch I submitted two days ago into two patches:
> the first one with just the logical changes, and the second one with
> just CodingStyle (whitespace) fixes.

Mauro,  I don't think anyone has maintained or used the v4l module in
ages.  You could be the new maintainer :)
Or at least have commit rights.  Just follow the instructions here:
http://www.freedesktop.org/wiki/AccountRequests

Alex

>
> Reworking on a driver with whitespace and identation problems is hard,
> as it makes harder for people to work with the source code.
>
> So, the first two patches have basically the same content as the patch
> I submitted earlier[1].
>
> [1] http://lists.x.org/archives/xorg-devel/2011-February/019042.html
>
> The fix patch I submited for xserver is still needed[2], otherwise
> loading the v4l driver with a video driver that doesn't support overlay
> will cause a server crash.
>
> [2] http://lists.x.org/archives/xorg-devel/2011-February/019048.html
>
> The remaining patches on this series fix some bugs found on the tests
> I made with:
>        1) a Nvidia FX5200 and the nv driver, and a bttv Encore FM board;
>        2) a Nvidia 6600 and nouveau driver, and a Kworld SBTV-D board
>          (to test it on an environment where Xv overlay is not available).
> And by some tests made by Dmitry Butskoy with a bttv AVerMedia TVPhone98
> board, with a Radeon RV100, using an old version of the Radeon driver.
>
> As I said before, the intention now is to port it to work with textured
> video. Help is wanted to point us how to use a textured video from the
> v4l driver.
>
> To make easier for people to test and review, the same patches are also
> available on a git repository at:
>        http://git.linuxtv.org/mchehab/xf86-video-v4l.git
>
> PS.: I'm c/c just this  message to the media devel ML, for people there
>     to be aware of the changes. There's not much sense to submit the
>     remaining patches there.
>
> Mauro Carvalho Chehab (8):
>  Port xf86-video-v4l driver to V4L2
>  Coding style Cleanup
>  Use the fourcc header instead of redefining it inside the code
>  Fix Get/Set Port Attribute logic
>  Return BadMatch if a Port Attribute is not found
>  Provide a more consistent message if FBUF fails
>  Fix arguments for v4l_check_yuv
>  Fix standard video size detection
>
>  src/v4l.c       | 1549 ++++++++++++++++++++++++++-------------------
>  src/videodev.h  |  254 --------
>  src/videodev2.h | 1929 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 2831 insertions(+), 901 deletions(-)
>  delete mode 100644 src/videodev.h
>  create mode 100644 src/videodev2.h
>
> _______________________________________________
> xorg-devel@lists.x.org: X.Org development
> Archives: http://lists.x.org/archives/xorg-devel
> Info: http://lists.x.org/mailman/listinfo/xorg-devel
>
