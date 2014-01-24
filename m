Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56159 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaAXNHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 08:07:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Detlev Casanova <detlev.casanova@gmail.com>,
	linux-media@vger.kernel.org, hyun.kwon@xilinx.com
Subject: Re: qv4l2 and media controller support
Date: Fri, 24 Jan 2014 14:08:35 +0100
Message-ID: <3336553.LUKAjLBShm@avalon>
In-Reply-To: <52E0507D.1060103@xs4all.nl>
References: <2270106.dN7Lhra68Q@avalon> <52E0507D.1060103@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 23 January 2014 00:13:01 Hans Verkuil wrote:
> Hi Laurent,
> 
> First, regarding the inheritance of subdev controls: I found it annoying as
> well that there is no way to do this. If you have a simple video pipeline,
> then having to create subdev nodes just to set a few controls is unnecessary
> complex. I've been thinking of adding a flag to the control handler that,
> when set, will 'import' the private controls. The bridge driver is the one
> that sets this as that is the only one that knows whether or not it is in
> fact a simple pipeline.

In my case the pipeline is potentially complex, given that it's implemented in 
an FPGA. The bridge driver just parses the DT pipeline representation and 
binds subdevs together. It has no concept of simple or complex pipelines. I've 
thus decided to go for an MC model, even for simple pipelines.

> Secondly, I'd love to add MC support to qv4l2. But I'm waiting for you to
> merge the MC library into v4l-utils.git. It's basically the reason why I
> haven't looked at this at all.

I assume that's a hint :-)

I've just posted a series of patches for libmediactl. Let's take it from 
there.

-- 
Regards,

Laurent Pinchart

