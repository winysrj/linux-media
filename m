Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:49942 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964788AbdBQXJh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 18:09:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Feb 2017 16:09:35 -0700
From: Shaobo <shaobo@cs.utah.edu>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com,
        ricardo.ribalda@gmail.com
Subject: Dead code or otherwise invalid memory access in
 drivers/media/v4l2-core/videobuf-core.c
Message-ID: <1d65f78dfdbbe733214f679e459864e8@cs.utah.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey guys,

I found that the definition and usage of macro `CALLPTR` may be 
problematic. Its definition is,

> 54 #define CALLPTR(q, f, arg...)                                        
>    \
> 55         ((q->int_ops->f) ? q->int_ops->f(arg) : NULL)

, which means it can evaluate to NULL. It has two occurrences: one in 
line 839 and the other is line 856. It appears to me that it's very 
likely that there will be invalid memory accesses if `CALLPTR` evaluates 
to NULL since there is no NULL test in either location. In other words, 
programmers' assumption suggest the else branch of the conditional 
expression dead. Please let me know if makes sense or not.

Thanks for your time and I am looking forward to your reply.

Best,
Shaobo
