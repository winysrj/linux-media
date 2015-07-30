Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36205 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbG3P0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 11:26:02 -0400
Received: by lagw2 with SMTP id w2so27334057lag.3
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 08:26:00 -0700 (PDT)
Date: Thu, 30 Jul 2015 18:25:56 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Peter Rabbitson <rabbit@rabbit.us>, linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Disable hardware timestamps by default
Message-ID: <20150730152555.GS18455@home.paul.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438006696-30678-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

I was experimenting with a web-camera integrated in my laptop and was
extremely confused by non-monotonic timestamps coming from the uvc
driver. In fact, the very first timestamp was bigger then the second
every time I tried. This patch helped.

More details:

1. I'm testing with

avconv -f video4linux2 -i /dev/video0 -codec copy test.mkv

2. Prior to applying the patch I was always getting "Non-monotonous
DTS in output stream 0:0" errors

3. I'm using kernel version 3.6.8 (yes, that's old, I'm ready to
upgrade if you really need that for debugging)

4. The camera is 5986:0100 Acer, Inc Orbicam

Anything else I can do to help you with this issue? My real usecase is
having a single-board computer capturing a steady stream from a UVC
webcam (h264 pixel format) while keeping timestamps reasonably
accurate (within 0.1s) for the future processing and spending as
little CPU time as possible.

Thank you in advance.
-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
