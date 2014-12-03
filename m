Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10452 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLCPC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 10:02:27 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NG000LWDHWNSJ60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Dec 2014 15:05:11 +0000 (GMT)
Message-id: <547F25F4.2000701@samsung.com>
Date: Wed, 03 Dec 2014 16:02:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: Re: [PATCH v4 05/10] v4l: of: Add v4l2_of_parse_link() function
References: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1417464820-6718-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1417464820-6718-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/12/14 21:13, Laurent Pinchart wrote:
> The function fills a link data structure with the device node and port
> number at both the local and remote ends of a link defined by one of its
> endpoint nodes.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-of.c | 61 +++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-of.h           | 27 +++++++++++++++++
>  2 files changed, 88 insertions(+)
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index b4ed9a9..c473479 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -142,3 +142,64 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
>  	return 0;
>  }
>  EXPORT_SYMBOL(v4l2_of_parse_endpoint);
> +
> +/**
> + * v4l2_of_parse_link() - parse a link between two endpoints
> + * @node: pointer to the endpoint at the local end of the link
> + * @link: pointer to the V4L2 OF link data structure
> + *
> + * Fill the link structure with the local and remote nodes and port numbers.
> + * The local_node and remote_node fields are set to point to the local and
> + * remote port parent nodes respectively (the port parent node being the parent

Not sure it that improves anything, but how about changing "remote port parent"
to "remote port's parent" ? I took me a while to understand this whole sentence.

Anyway the patch looks good to me.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> + * node of the port node if that node isn't a 'ports' node, or the grand-parent
> + * node of the port node otherwise).
> + *
> + * A reference is taken to both the local and remote nodes, the caller must use
> + * v4l2_of_put_link() to drop the references when done with the link.
> + *
> + * Return: 0 on success, or -ENOLINK if the remote endpoint can't be found.
> + */

--
Regards,
Sylwester
