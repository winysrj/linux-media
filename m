Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:40040 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbAWTtW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 14:49:22 -0500
Received: by mail-qa0-f43.google.com with SMTP id v10so7370488qac.2
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2015 11:49:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C2A2B1.2020301@osg.samsung.com>
References: <1421970125-8169-1-git-send-email-shuahkh@osg.samsung.com>
	<54C21952.7010602@xs4all.nl>
	<54C26204.9000106@osg.samsung.com>
	<54C29E3E.7010009@osg.samsung.com>
	<54C2A2B1.2020301@osg.samsung.com>
Date: Fri, 23 Jan 2015 14:49:21 -0500
Message-ID: <CAGoCfiwhGNC=C+txSK8tTjpYb+q0rQkHFb4Q_0cYop+1L6oJLQ@mail.gmail.com>
Subject: Re: [PATCH v4] media: au0828 - convert to use videobuf2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tim Mester <ttmesterr@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

> TRY_FMT and S_FMT both don't handle invalid pixelformats. Looks like
> there is reason behind this based on the comments:
>
>  /* format->fmt.pix.width only support 720 and height 480 */
>         if (width != 720)
>                 width = 720;
>         if (height != 480)
>                 height = 480;

This actually isn't a bug, and in fact I believe the v4l2-compliance
tool prints out a URL to a thread you should read.  It has to do with
the HVR-950q hardware delivering UYVY video and the behavior being
unspecified for how non-supported pixel formats should be handled
until relatively recently.  As a result, it behaves that way so apps
like tvtime don't break due to expecting legacy behavior.

It has nothing to do with the resolution - in fact the driver is doing
exactly what it is supposed to (if you provide an unsupported
resolution, the driver is supposed to pass back a resolution that is
good and still return success).  It's the application's responsibility
to look at the resolution in the struct after the ioctl call and make
sure it hasn't changed (and if it has, the app should adjust its
expectations accordingly).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
