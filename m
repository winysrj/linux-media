Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39430 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752435AbcHQTvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 15:51:17 -0400
Date: Wed, 17 Aug 2016 22:50:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] [media] vb2: defer sync buffers from
 vb2_buffer_done() with a workqueue
Message-ID: <20160817195027.GE3182@valkosipuli.retiisi.org.uk>
References: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
 <1471458537-16859-2-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471458537-16859-2-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Wed, Aug 17, 2016 at 02:28:56PM -0400, Javier Martinez Canillas wrote:
> The vb2_buffer_done() function can be called from interrupt context but it
> currently calls the vb2 memory allocator .finish operation to sync buffers
> and this can take a long time, so it's not suitable to be done there.
> 
> This patch defers part of the vb2_buffer_done() logic to a worker thread
> to avoid doing the time consuming operation in interrupt context.

I agree the interrupt handler is not the best place to perform the work in
vb2_buffer_done() (including cache flushing), but is a work queue an ideal
solution?

The work queue task is a regular kernel thread not subject to
sched_setscheduler(2) and alike, which user space programs can and do use to
change how the scheduler treats these processes. Requiring a work queue to
be run between the interrupt arriving from the hardware and the user space
process being able to dequeue the related buffer would hurt use cases where
strict time limits are crucial.

Neither I propose making the work queue to have real time priority either,
albeit I think might still be marginally better.

Additionally, the work queue brings another context switch per dequeued
buffer. This would also be undesirable on IoT and mobile systems that often
handle multiple buffer queues simultaneously.

Performing this task in the context of the process that actually dequeues
the buffer avoids both of these problem entirely as there are no other
processes involved.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
