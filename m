Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55803 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdDJKvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 06:51:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Roschka <danielroschka@phoenitydawn.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Quirk for webcam in MacBook Pro 2016
Date: Mon, 10 Apr 2017 13:52:21 +0300
Message-ID: <9504811.tIhrXQ8rYn@avalon>
In-Reply-To: <2780663.rcqhCkWply@buzzard>
References: <4643839.ui0SUBUoba@buzzard> <2780663.rcqhCkWply@buzzard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Sunday 09 Apr 2017 19:43:22 Daniel Roschka wrote:
> Hi Laurent,
> 
> I don't want to sound impatient, but I as I don't know what your usual
> reaction times to patches are and already waited three weeks without any
> reaction, I kindly want to ask, if you already had a chance to look into
> this patch and consider it for inclusion into your tree?

Thank you for pinging me, the patch was indeed buried under a pile of other e-
mails :-)

Your mail client (or server, I don't know) mangled the patch by replacing tabs 
with spaces. As the patch is short I've fixed this manually, but next time 
please try to fix the issue on your side.

Another small issue is that the commit message should be wrapped at 72 
columns. Depending on the text editor you use, git commit usually does that 
automatically for you.

I've also added a "uvcvideo: " prefix to the subject line, otherwise short git 
logs wouldn't be very clear. As a rule of thumb, your subject line should 
contain enough information to understand which driver the patch relates to, 
and what it does.

Your patch is now in my git tree, and I will push it upstream for v4.13 (v4.11 
will be released very soon, and given the pending pull requests for v4.12 in 
the Linux media tree I don't think I can add another one).

I collect USB descriptors for UVC devices. Could you please send me the output 
of

lsusb -d 05ac:8600

if possible running as root ?

Thank you for your contribution !

-- 
Regards,

Laurent Pinchart
