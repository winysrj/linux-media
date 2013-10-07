Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1787 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JGH5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 03:57:22 -0400
Message-ID: <52526959.8020701@xs4all.nl>
Date: Mon, 07 Oct 2013 09:57:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-omap@vger.kernel.org, tomi.valkeinen@ti.com
Subject: Re: [PATCH v4 4/4] v4l: ti-vpe: Add de-interlacer support in VPE
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1378462346-10880-1-git-send-email-archit@ti.com> <1378462346-10880-5-git-send-email-archit@ti.com>
In-Reply-To: <1378462346-10880-5-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2013 12:12 PM, Archit Taneja wrote:
> Add support for the de-interlacer block in VPE.
> 
> For de-interlacer to work, we need to enable 2 more sets of VPE input ports
> which fetch data from the 'last' and 'last to last' fields of the interlaced
> video. Apart from that, we need to enable the Motion vector output and input
> ports, and also allocate DMA buffers for them.
> 
> We need to make sure that two most recent fields in the source queue are
> available and in the 'READY' state. Once a mem2mem context gets access to the
> VPE HW(in device_run), it extracts the addresses of the 3 buffers, and provides
> it to the data descriptors for the 3 sets of input ports((LUMA1, CHROMA1),
> (LUMA2, CHROMA2), and (LUMA3, CHROMA3)) respectively for the 3 consecutive
> fields. The motion vector and output port descriptors are configured and the
> list is submitted to VPDMA.
> 
> Once the transaction is done, the v4l2 buffer corresponding to the oldest
> field(the 3rd one) is changed to the state 'DONE', and the buffers corresponding
> to 1st and 2nd fields become the 2nd and 3rd field for the next de-interlace
> operation. This way, for each deinterlace operation, we have the 3 most recent
> fields. After each transaction, we also swap the motion vector buffers, the new
> input motion vector buffer contains the resultant motion information of all the
> previous frames, and the new output motion vector buffer will be used to hold
> the updated motion vector to capture the motion changes in the next field. The
> motion vector buffers are allocated using the DMA allocation API.
> 
> The de-interlacer is removed from bypass mode, it requires some extra default
> configurations which are now added. The chrominance upsampler coefficients are
> added for interlaced frames. Some VPDMA parameters like frame start event and
> line mode are configured for the 2 extra sets of input ports.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 392 ++++++++++++++++++++++++++++++++----
>  1 file changed, 358 insertions(+), 34 deletions(-)
> 

