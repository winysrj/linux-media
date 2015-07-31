Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38067 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659AbbGaOoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 10:44:07 -0400
Date: Fri, 31 Jul 2015 17:43:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] vb2: revert: vb2: allow requeuing buffers while streaming
Message-ID: <20150731144334.GE15270@valkosipuli.retiisi.org.uk>
References: <1438183745-2652-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438183745-2652-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve,

On Wed, Jul 29, 2015 at 06:29:05PM +0300, Antti Palosaari wrote:
> commit ce0eff016f7272faa6dc6eec722b1ca1970ff9aa
> [media] vb2: allow requeuing buffers while streaming
> 
> That commit causes buf_queue() called on infinity loop when
> start_streaming() returns error. On that case resources are eaten
> quickly and machine crashes.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Fixed by this patch in media-fixes:

commit 6d058c5643e16779ae4c001d2e893c140940e48f
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Fri Jul 3 04:37:07 2015 -0300

    [media] vb2: Only requeue buffers immediately once streaming is started
    
    Buffers can be returned back to videobuf2 in driver's streamon handler. In
    this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
    cause the driver's buf_queue vb2 operation to be called, queueing the same
    buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
    on.
    
    Add a new buffer state VB2_BUF_STATE_REQUEUEING which, when used as the
    state argument to vb2_buffer_done(), will result in buffers queued to the
    driver. Using VB2_BUF_STATE_QUEUED will leave the buffer to videobuf2, as it
    was before "[media] vb2: allow requeuing buffers while streaming".
    
    Fixes: ce0eff016f72 ("[media] vb2: allow requeuing buffers while streaming")
    
    [mchehab@osg.samsung.com: fix warning: enumeration value 'VB2_BUF_STATE_REQUEUEING' not handled in switch]
    
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
    Cc: stable@vger.kernel.org # for v4.1
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

-- 
Terveisin,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
