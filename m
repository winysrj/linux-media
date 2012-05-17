Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4977 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab2EQHxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 03:53:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jun Nie <niej0001@gmail.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
Date: Thu, 17 May 2012 09:53:03 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1202201633100.2836@axis700.grange> <CAGA24M+OEwi-ayBrXcMPg5PzndRF4mSr2dOOQAxhDCu6ShZLjQ@mail.gmail.com>
In-Reply-To: <CAGA24M+OEwi-ayBrXcMPg5PzndRF4mSr2dOOQAxhDCu6ShZLjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205170953.03093.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu May 17 2012 04:46:37 Jun Nie wrote:
>     Is there any discussion on HDCP on the summit? It is tightly
> coupled with HDMI and DVI and should be managed together with the
> transmitter. But there is not code to handle HDCP in DRM/FB/V4L in
> latest kernel. Any thoughts on HDCP? Or you guys think there is risk
> to support it in kernel? Thanks for your comments!

There is no risk to support it in the kernel, the risk is all for the
implementer (usually by having to lock down the system preventing access
to the box). You'd better read the HDCP license very carefully before deciding
to use HDCP under linux!

I'm working on V4L HDMI receivers and transmitters myself, but not on HDCP.
But I'd be happy to review/comment on proposals for adding HDCP support.

Note that there is very little work to be done to add this for simple
receivers and transmitters. The hard part will be supporting repeaters.

For simple receivers all you need in V4L2 is a flag telling you that the
received video was encrypted and for a transmitter I think you just need a
control to turn encryption on or off (AFAIK, I'd have to verify that statement
regarding the transmitter to be 100% certain). All the actual encryption and
decryption is handled by the receiver/transmitter hardware, at least on the
hardware that I have seen.

Repeaters are a lot harder as you have to handle key exchanges. I don't know
off-hand what that would involve API-wise in V4L2.

Regards,

	Hans
