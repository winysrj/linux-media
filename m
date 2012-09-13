Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2IMKQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 15/28] DocBook: Mark CROPCAP as optional instead of as compulsory.
Date: Thu, 13 Sep 2012 04:32:59 +0200
Message-ID: <1384393.dLQ2aBEs8V@avalon>
In-Reply-To: <a24d3d2fd37d687a6dd5d909e6e5e3606edaf5ea.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <a24d3d2fd37d687a6dd5d909e6e5e3606edaf5ea.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:15 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> While the documentation says that VIDIOC_CROPCAP is compulsory for
> all video capture and output devices, in practice VIDIOC_CROPCAP is
> only implemented for devices that can do cropping and/or scaling.
> 
> Update the documentation to no longer require VIDIOC_CROPCAP if the
> driver does not support cropping or scaling or non-square pixels.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/common.xml         |  145 ++++++++---------
>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml |   10 +-
>  2 files changed, 75 insertions(+), 80 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/common.xml
> b/Documentation/DocBook/media/v4l/common.xml index 9378d7b..454258b 100644
> --- a/Documentation/DocBook/media/v4l/common.xml
> +++ b/Documentation/DocBook/media/v4l/common.xml
> @@ -628,7 +628,7 @@ are available for the device.</para>
>  if (-1 == ioctl (fd, &VIDIOC-G-STD;, &amp;std_id)) {
>  	/* Note when VIDIOC_ENUMSTD always returns EINVAL this
>  	   is no video device or it falls under the USB exception,
> -	   and VIDIOC_G_STD returning EINVAL is no error. */
> +	   and VIDIOC_G_STD returning ENOTTY is no error. */
> 
>  	perror ("VIDIOC_G_STD");
>  	exit (EXIT_FAILURE);

Would this hunk make more sense in patch 11/28 ?

-- 
Regards,

Laurent Pinchart

