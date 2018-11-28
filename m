Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48842 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727872AbeK2Bgp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 20:36:45 -0500
Date: Wed, 28 Nov 2018 16:34:51 +0200
From: sakari.ailus@iki.fi
To: hverkuil-cisco@xs4all.nl
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: Re: [PATCH for v4.20 0/5] vb2 fixes (mostly request API related)
Message-ID: <20181128143451.6m5i5v7le2p5ynm4@valkosipuli.retiisi.org.uk>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 28, 2018 at 09:37:42AM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> While improving the v4l2-compliance tests I came across several vb2
> problems.
> 
> After modifying v4l2-compliance I was now able to use the vivid error
> injection feature to test what happens if VIDIOC_STREAMON fails and
> a following STREAMON succeeds.
> 
> This generated patches 1/5 and 4/5+5/5.
> 
> Patch 1/5 fixes an issue that was never noticed before since it didn't
> result in kernel oopses or warnings, but after the second STREAMON it
> won't call start_streaming anymore until you call REQBUFS(0) or close
> the device node.
> 
> Patches 4 and 5 are request specific fixes for the same corner case:
> the code would unbind (in vb2) or complete (in vivid) a request if
> start_streaming fails, but it should just leave things as-is. The
> buffer is just put back in the queue, ready for the next attempt at
> STREAMON.
> 
> Patch 2/5 was also discovered by v4l2-compliance: the request fd in
> v4l2_buffer should be ignored by VIDIOC_PREPARE_BUF, but it wasn't.
> 
> Patch 3/5 fixes a nasty corner case: a buffer with associated request
> is queued, and then the request fd is closed by v4l2-compliance.
> 
> When the driver calls vb2_buffer_done, the buffer request object is
> unbound, the object is put, and indirectly the associated request
> is put as well, and since that was the last references to the request
> the whole request is released, which requires the ability to call
> mutex_lock. But vb2_buffer_done is atomic (it can be called
> from interrupt context), so this shouldn't happen.
> 
> vb2 now takes an extra refcount to the request on qbuf and releases
> it on dqbuf and at two other places where an internal dqbuf is done.
> 
> Note that 'skip request checks for VIDIOC_PREPARE_BUF' is a duplicate
> of https://patchwork.linuxtv.org/patch/53171/, which is now marked as
> superseded.
> 
> I've marked all these patches for 4.20, but I think it is also possible
> to apply them for 4.21 since the request API is only used by virtual
> drivers and a staging driver.

For patches 2--5:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
