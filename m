Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39091 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbdBVTy2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 14:54:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shaobo <shaobo@cs.utah.edu>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com,
        ricardo.ribalda@gmail.com
Subject: Re: Dead code in v4l2-mem2mem.c?
Date: Wed, 22 Feb 2017 21:54:47 +0200
Message-ID: <1639695.jbRSfuVV0g@avalon>
In-Reply-To: <000601d28bb2$6d0ca330$4725e990$@cs.utah.edu>
References: <002201d288a9$93dd7360$bb985a20$@cs.utah.edu> <2249581.t3xTjk4llj@avalon> <000601d28bb2$6d0ca330$4725e990$@cs.utah.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaobo,

On Monday 20 Feb 2017 12:49:18 Shaobo wrote:
> Hi Laurent,
> 
> I'd like to. It sounds interesting and useful to me. Could you give me some
> pointers about how to audit drivers?

It's pretty simple, you need to check all functions that call get_queue_ctx() 
and follow the call stacks up to drivers to see if the context can be NULL. 
It's a bit of work though :-)

-- 
Regards,

Laurent Pinchart
