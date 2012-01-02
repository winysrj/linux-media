Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40994 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2ABLFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 06:05:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: MEM2MEM devices: how to handle sequence number?
Date: Mon, 2 Jan 2012 12:06:04 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de, Pawel Osciak <p.osciak@gmail.com>
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com> <201112252219.11412.laurent.pinchart@ideasonboard.com> <CACKLOr3cZvM-oH+s7tcfnnDAsrqSP6TVV9UVhJ6o4FJz8RxmiA@mail.gmail.com>
In-Reply-To: <CACKLOr3cZvM-oH+s7tcfnnDAsrqSP6TVV9UVhJ6o4FJz8RxmiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201021206.06397.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Monday 02 January 2012 11:22:54 javier Martin wrote:
> Hi,
> i've just arrived the office after holidays and it seems you have
> agreed some solution to the sequence number issue.
> 
> As I understand, for a case where there is 1:1 correspondence between
> input and output (which is my case) I should do the following:
> 
> - keep an internal frame counter associated with the output queue.
> - return the frame number when the user calls VIDIOC_QBUF on the output.
> - pass the output frame number to the capture queue in a 1:1 basis

That's right.

> So in my chain of three processed nodes each node has its own internal
> frame counter and frame loss should be checked at the video source.

You can use an internal frame counter for each node if needed for internal 
operation, but that's not required from the userspace point of view.

> Is that OK?

-- 
Regards,

Laurent Pinchart
