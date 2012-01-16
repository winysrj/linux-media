Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:53442 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2APKik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 05:38:40 -0500
Received: from mail2.matrix-vision.com (localhost [127.0.0.1])
	by mail2.matrix-vision.com (Postfix) with ESMTP id C719E3F655
	for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 11:32:14 +0100 (CET)
Received: from erinome (g2.matrix-vision.com [80.152.136.245])
	by mail2.matrix-vision.com (Postfix) with ESMTPA id 969973F653
	for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 11:32:14 +0100 (CET)
Received: from erinome (localhost [127.0.0.1])
	by erinome (Postfix) with ESMTP id 0AF736F8A
	for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 11:32:14 +0100 (CET)
Received: from [192.168.65.136] (host65-136.intern.matrix-vision.de [192.168.65.136])
	by erinome (Postfix) with ESMTPA id DE73C6F8A
	for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 11:32:13 +0100 (CET)
Message-ID: <4F13FCB3.10804@matrix-vision.de>
Date: Mon, 16 Jan 2012 11:32:19 +0100
From: Kruno Mrak <kruno.mrak@matrix-vision.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: omap3isp: sequence number in v4l2 buffer not incremented
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

we have an omap based intelligent camera and
image sensor is connected to camera parallel interface.
Image capturing via "CCDC output" works fine.
When streaming is on and reading "sequence" variable, it shows
always -1.
Looking at kernel-source ispvideo.c, i found following
if-else statement:

/* Do frame number propagation only if this is the output video node.
  * Frame number either comes from the CSI receivers or it gets
  * incremented here if H3A is not active.
  * Note: There is no guarantee that the output buffer will finish
  * first, so the input number might lag behind by 1 in some cases.
  */
if (video == pipe->output && !pipe->do_propagation)
	buf->vbuf.sequence = atomic_inc_return(&pipe->frame_number);
else
	buf->vbuf.sequence = atomic_read(&pipe->frame_number);

When i change to
if (video == pipe->output && pipe->do_propagation)
...
the sequence variable is incremented.

So my questions:
Could it be that "pipe->do_propagation" should be tested on true and
not on false?
If my changes are wrong, is there a reason why the sequence is not 
incremented?


Thanks,
Kruno Mrak



MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
