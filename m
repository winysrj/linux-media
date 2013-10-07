Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1968 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3JGHqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 03:46:46 -0400
Message-ID: <525266DC.5020409@xs4all.nl>
Date: Mon, 07 Oct 2013 09:46:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-omap@vger.kernel.org, tomi.valkeinen@ti.com
Subject: Re: [PATCH v4 2/4] v4l: ti-vpe: Add helpers for creating VPDMA descriptors
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1378462346-10880-1-git-send-email-archit@ti.com> <1378462346-10880-3-git-send-email-archit@ti.com>
In-Reply-To: <1378462346-10880-3-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2013 12:12 PM, Archit Taneja wrote:
> Create functions which the VPE driver can use to create a VPDMA descriptor and
> add it to a VPDMA descriptor list. These functions take a pointer to an existing
> list, and append the configuration/data/control descriptor header to the list.
> 
> In the case of configuration descriptors, the creation of a payload block may be
> required(the payloads can hold VPE MMR values, or scaler coefficients). The
> allocation of the payload buffer and it's content is left to the VPE driver.
> However, the VPDMA library provides helper macros to create payload in the
> correct format.
> 
> Add debug functions to dump the descriptors in a way such that it's easy to see
> the values of different fields in the descriptors.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/ti-vpe/vpdma.c      | 268 +++++++++++++++
>  drivers/media/platform/ti-vpe/vpdma.h      |  48 +++
>  drivers/media/platform/ti-vpe/vpdma_priv.h | 522 +++++++++++++++++++++++++++++
>  3 files changed, 838 insertions(+)
> 

