Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:43915 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092AbaFFWLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jun 2014 18:11:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTP id C8D5C4722E5
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 23:11:10 +0100 (BST)
Received: from ducie-dc1.codethink.co.uk ([127.0.0.1])
	by localhost (ducie-dc1.codethink.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FATTACZtwXSH for <linux-media@vger.kernel.org>;
	Fri,  6 Jun 2014 23:11:05 +0100 (BST)
Received: from snark.dyn.ducie.codethink.co.uk (unknown [87.115.186.173])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTPSA id 6F18F47228F
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 23:11:05 +0100 (BST)
Date: Fri, 6 Jun 2014 23:11:04 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Subject: rcar_vin, soc_camera and videobuf2
Message-Id: <20140606231104.977abe8df6291adccd1813c3@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi folks,

A colleague and I have been attempting to debug issues with rcar_vin, soc_camera, and videobuf2.

Presently, We're using the adv7180 frontend to feed composite video to the rcar hardware.

Using the streamer utility from xawtv3 (as packaged by wheezy), we have been able to capture both stills and video, however there are significant issues.

There are a lot of warnings triggered in the videobuf2 code, primarily in videobuf2-core.c

in vb2_buffer_done() we found that it appears that q->start_streaming_called is 0, due to the following code in __vb2_queue_cancel().


 q->streaming = 0;
 q->start_streaming_called = 0;
 q->queued_count = 0;

 if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
                for (i = 0; i < q->num_buffers; ++i) {
                        if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
                                vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
                }
                /* Must be zero now */
                WARN_ON(atomic_read(&q->owned_by_drv_count));
 }

This causes the code in vb2_buffer_done() to follow the "DMA path" and thus generate a warning.

Moving the first three lines afer the if() clause means that we no longer see the WARN_ON(state != VB2_BUF_STATE_QUEUED) in vb2_buffer_done(), however, we still see the WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE) later in the process.

When capturing video, the driver also exhibits very odd behaviour, including apparently time running backwards, which appears to be the result of queuing buffers in the wrong order. We also see a lot of messages re: buffers being queued twice.

Looking at the rcar_vin driver, it appears to perform its allocations quite differently from other soc_camera drivers.

Does anyone have any guidance on how to proceed? Clearly the state machine is being violated here, but I'm at a loss as to how its actually *supposed* to operate. Is there any good documentation?

-- 
Ian Molton <ian.molton@codethink.co.uk>
