Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36402 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbbBBNs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 08:48:57 -0500
Message-ID: <54CF8020.5090106@xs4all.nl>
Date: Mon, 02 Feb 2015 14:48:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>
Subject: Re: [RFC PATCH 1/2] [media] videodev2: Add V4L2_BUF_FLAG_LAST
References: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de> <1421926118-29535-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1421926118-29535-2-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2015 12:28 PM, Philipp Zabel wrote:
> From: Peter Seiderer <ps.report@gmx.net>
> 
> This v4l2_buffer flag can be used by drivers to mark a capture buffer
> as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
> command was issued.
> 
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  include/uapi/linux/videodev2.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index fbdc360..c642c10 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -809,6 +809,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
>  #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
>  #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
> +/* mem2mem encoder/decoder */
> +#define V4L2_BUF_FLAG_LAST			0x00100000
>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
> 

You probably knew this, but this should of course be documented in the V4L2
spec. In particular the spec should be clear about *when* the flag is set.

Also, any drivers that need this should be updated as well. Otherwise applications
cannot rely on it.

Regards,

	Hans
