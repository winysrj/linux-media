Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:48518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751542AbeBWMl6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 07:41:58 -0500
Date: Fri, 23 Feb 2018 14:41:55 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] media: fix build issues with vb2-trace
Message-ID: <20180223124155.t6a7jzmyb55vqrmz@paasikivi.fi.intel.com>
References: <ad9dda912622864ead2349eb66a94bb7df18615f.1519380628.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad9dda912622864ead2349eb66a94bb7df18615f.1519380628.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 23, 2018 at 05:10:38AM -0500, Mauro Carvalho Chehab wrote:
> There was a trouble with vb2-trace: instead of being part of
> VB2 core, it was stored at V4L2 videodev. That was wrong,
> as it doesn't actually belong to V4L2 core.
> 
> Now that vb2 is not part of v4l2-core, its trace functions
> should be moved altogether. So, move it to its rightful
> place: at videobuf2-core.
> 
> That fixes those errors:
> 	drivers/media/common/videobuf2/videobuf2-core.o: In function `__read_once_size':
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
> 	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
> 	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x10): undefined reference to `__tracepoint_vb2_buf_queue'
> 	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x28): undefined reference to `__tracepoint_vb2_buf_done'
> 	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x40): undefined reference to `__tracepoint_vb2_qbuf'
> 	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x58): undefined reference to `__tracepoint_vb2_dqbuf'
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
