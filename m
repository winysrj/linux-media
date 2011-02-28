Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54777 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809Ab1B1NdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 08:33:15 -0500
Subject: Re: [RFC] snapshot mode, flash capabilities and control
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
In-Reply-To: <201102281217.12538.hansverk@cisco.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
	 <Pine.LNX.4.64.1102281148310.11156@axis700.grange>
	 <201102281207.34106.laurent.pinchart@ideasonboard.com>
	 <201102281217.12538.hansverk@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 08:33:44 -0500
Message-ID: <1298900024.2137.31.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-28 at 12:17 +0100, Hans Verkuil wrote:
> On Monday, February 28, 2011 12:07:33 Laurent Pinchart wrote:

> > > So, do I understand it right, that currently there are drivers, that
> > > overwrite the last buffers while waiting for a new one, and ones, that
> > > stop capture for that time.
> 
> Does anyone know which drivers stop capture if there are no buffers available? 
> I'm not aware of any.

Not that it is a camera driver, but...

cx18 will stall the stream, due to the CX23418 engine being starved of
buffers for that stream, if the application doesn't read the buffers.
The reasoning for this behavior is that one large gap is better than a
series of small gaps, if the application has fallen behind.

The exceptional case is the cx18 MPEG Index stream, which will steal the
oldest buffers back in the call to cx18_stream_rotate_idx_mdls().

The CX23418 engine seems to gracefully handle being starved of buffers
for a stream for a period of time.

This driver does not use videobuf currently.

-Andy

