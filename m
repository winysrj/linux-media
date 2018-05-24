Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44460 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965450AbeEXIoU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 04:44:20 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: RFC: Request API and memory-to-memory devices
Message-ID: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl>
Date: Thu, 24 May 2018 10:44:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory-to-memory devices have one video node, one internal control handler
but two vb2_queues (DMA engines). While often there is one buffer produced
for every buffer consumed, but this is by no means standard. E.g. deinterlacers
will produce on buffer for every two buffers consumed. Codecs that receive
a bit stream and can parse it to discover the framing may have no relation
between the number of buffers consumed and the number of buffers produced.

This poses a few problems for the Request API. Requiring that a request
contains the buffers for both output and capture queue will be difficult
to implement, especially in the latter case where there is no relationship
between the number of consumed and produced buffers.

In addition, userspace can make two requests: one for the capture queue,
one for the output queue, each with associated controls. But since the
controls are shared between capture and output there is an issue of
what to do when the same control is set in both requests.

I propose to restrict the usage of requests for m2m drivers to the output
queue only. This keeps things simple for both kernel and userspace and
avoids complex solutions.

Requests only make sense if there is actually configuration you can apply
for each buffer, and while that's true for the output queue, on the capture
queue you just capture the result of whatever the device delivers. I don't
believe there is much if anything you can or want to control per-buffer.

Am I missing something? Comments?

Regards,

	Hans
