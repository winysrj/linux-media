Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46265 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab1LATBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 14:01:31 -0500
Received: by iage36 with SMTP id e36so2879935iag.19
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2011 11:01:31 -0800 (PST)
Message-ID: <4ED7CF04.8050906@gmail.com>
Date: Thu, 01 Dec 2011 14:01:24 -0500
From: damateem <damateem4@gmail.com>
MIME-Version: 1.0
To: linux-media list <linux-media@vger.kernel.org>
Subject: Re: Debug output
References: <4ED6CE53.7010806@gmail.com>
In-Reply-To: <4ED6CE53.7010806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, if I set debug as follows

vfd->debug =V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;

I can see the debug trace in dmesg, but this doesn't seem like the
correct way to set the flags.

What is the typical method of setting these debug flags?

Is this the best place to ask these type of questions?

Thanks,
David


On 11/30/2011 7:46 PM, damateem wrote:
> There are a fair number of debug print statements in the V4L2 code. How
> do I turn those on?
>
> For instance, I'd like the following code to print
>
> if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
>                 !(vfd->debug & V4L2_DEBUG_IOCTL_ARG)) {
>         v4l_print_ioctl(vfd->name, cmd);
>         printk(KERN_CONT "\n");
>     }
>
> so I can trace the IOCTL calls.
>
> Thanks,
> David
