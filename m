Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3454 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaEGKMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 06:12:33 -0400
Message-ID: <536A0709.5090605@xs4all.nl>
Date: Wed, 07 May 2014 12:12:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: vb2_reqbufs() is not allowing more than VIDEO_MAX_FRAME
References: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>
In-Reply-To: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Divneil,

On 05/07/14 11:37, Divneil Wadhawan wrote:
> Hi,
> 
> 
> I have a driver which is MUXING out data taking in multiple inputs.
> 
> It has been found in certain cases, at the minimum 40 buffers are
> required to be queued before it could MUX out anything.
> 
> Currently, VIDEO_MAX_FRAME is restricting the max size to 32. This
> can be over-ridden in driver queue_setup, but, it is making it
> mandatory to use always a particular count. So, it takes the
> independence from application to allocate any count> 32.
> 
> So, is it okay to revise this limit or introduce a new queue->depth
> variable which could be used in conjuction with VIDEO_MAX_FRAME to
> determine the num_buffers.

Hmm, I always wondered when this would happen.

The right approach would be to add a VB2_MAX_FRAME define to videobuf2-core.h
and use that in any v4l2 driver that uses videobuf2. VIDEO_MAX_FRAME
really shouldn't be in a public API, but I don't think we can remove it
since it's been there for ages.

The maximum number of frames is really a property of vb2 (and the older
videobuf, but I don't want to tamper with that) and as such it would be
no problem increasing it to 64.

In theory we could make the number of maximum frames driver specific, but
it would be more trouble than it's worth at the moment IMHO.

If we ever get drivers that need more than 64 buffers, then we can
always reconsider.

Which driver are you using? Is it something that you or someone else is
likely to upstream to the linux kernel?

Regards,

	Hans
