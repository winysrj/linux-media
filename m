Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50533 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2BOPxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 10:53:48 -0500
Received: by bkcjm19 with SMTP id jm19so1069389bkc.19
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2012 07:53:47 -0800 (PST)
Message-ID: <4F3BD50A.3010608@uni-bielefeld.de>
Date: Wed, 15 Feb 2012 16:53:46 +0100
From: Robert Abel <abel@uni-bielefeld.de>
Reply-To: abel@uni-bielefeld.de
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [libv4l] Bytes per Line
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

First off, I hope this is the right mailing list I'm writing to.

Basically, I found that libv4l and its conversion functions usually
choose to ignore v4l2_pix_format.bytesperline, which seems to work out
most of the time.

I'm currently working with the mt9v032 camera on a Gumstix Overo board.
The mt9v032's driver pads output lines to 768 pixels, giving 0x900 bytes
per line. All code in bayer.c (the camera uses raw bayer pattern) is
written to assume bytesperline = width and thus everything goes horribly
wrong.

I patched the issue for bayer => rgbbgr24 and will possibly fix it for
bayer => yuv as well.
However, I am going to run some tests using test patterns comparing
bayer => rgb to bayer => yuv => rgb, where the bayer => yuv part is done
in hardware. Yet, the code for yuv => rgb does also not take
bytesperline into account.

Is there a general understanding that v4l media drivers must not pad
their data, or that libv4l is ignoring padding?
I've worked with some webcams in the past and they all padded their
data, so I'm wondering if assuming bytesperline = width was done on
purpose and by design of out of necessity (speed..?) or if it just
happened to work for most people?

Thanks,

Robert
