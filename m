Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:38966 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3EVKhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 06:37:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [RFC] [media] mem2mem: add support for hardware buffered queue
Date: Wed, 22 May 2013 12:36:48 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305221236.48467.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 22 May 2013 12:17:36 Philipp Zabel wrote:
> On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
> buffer at the end of the stream, remaining frames might need to be decoded
> without additional input buffers being provided, and after calling streamoff
> on the v4l2 output queue. This also allows a driver to copy input buffers
> into their bitstream ringbuffer and immediately mark them as done to be
> dequeued.
> 
> The motivation for this patch is hardware assisted h.264 reordering support
> in the coda driver. For high profile streams, the coda can hold back
> out-of-order frames, causing a few mem2mem device runs in the beginning, that
> don't produce any decompressed buffer at the v4l2 capture side. At the same
> time, the last few frames can be decoded from the bitstream with mem2mem device
> runs that don't need a new input buffer at the v4l2 output side. A streamoff
> on the v4l2 output side can be used to put the decoder into the ringbuffer
> draining end-of-stream mode.

This is just a pointer to a related issue: how to signal to the application
that the end-of-stream has been reached:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg60916.html

How does the coda driver handle eos signalling?

Regards,

	Hans
