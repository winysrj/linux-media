Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54684 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1LAAqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 19:46:17 -0500
Received: by ghrr1 with SMTP id r1so1262058ghr.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 16:46:16 -0800 (PST)
Message-ID: <4ED6CE53.7010806@gmail.com>
Date: Wed, 30 Nov 2011 19:46:11 -0500
From: damateem <damateem4@gmail.com>
MIME-Version: 1.0
To: linux-media list <linux-media@vger.kernel.org>
Subject: Debug output
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a fair number of debug print statements in the V4L2 code. How
do I turn those on?

For instance, I'd like the following code to print

if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
                !(vfd->debug & V4L2_DEBUG_IOCTL_ARG)) {
        v4l_print_ioctl(vfd->name, cmd);
        printk(KERN_CONT "\n");
    }

so I can trace the IOCTL calls.

Thanks,
David
