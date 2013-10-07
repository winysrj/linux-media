Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2688 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3JGHq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 03:46:29 -0400
Message-ID: <525266C9.5070404@xs4all.nl>
Date: Mon, 07 Oct 2013 09:46:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-omap@vger.kernel.org, tomi.valkeinen@ti.com
Subject: Re: [PATCH v4 1/4] v4l: ti-vpe: Create a vpdma helper library
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1378462346-10880-1-git-send-email-archit@ti.com> <1378462346-10880-2-git-send-email-archit@ti.com>
In-Reply-To: <1378462346-10880-2-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2013 12:12 PM, Archit Taneja wrote:
> The primary function of VPDMA is to move data between external memory and
> internal processing modules(in our case, VPE) that source or sink data. VPDMA is
> capable of buffering this data and then delivering the data as demanded to the
> modules as programmed. The modules that source or sink data are referred to as
> clients or ports. A channel is setup inside the VPDMA to connect a specific
> memory buffer to a specific client. The VPDMA centralizes the DMA control
> functions and buffering required to allow all the clients to minimize the
> effect of long latency times.
> 
> Add the following to the VPDMA helper:
> 
> - A data struct which describe VPDMA channels. For now, these channels are the
>   ones used only by VPE, the list of channels will increase when VIP(Video
>   Input Port) also uses the VPDMA library. This channel information will be
>   used to populate fields required by data descriptors.
> 
> - Data structs which describe the different data types supported by VPDMA. This
>   data type information will be used to populate fields required by data
>   descriptors and used by the VPE driver to map a V4L2 format to the
>   corresponding VPDMA data type.
> 
> - Provide VPDMA register offset definitions, functions to read, write and modify
>   VPDMA registers.
> 
> - Functions to create and submit a VPDMA list. A list is a group of descriptors
>   that makes up a set of DMA transfers that need to be completed. Each
>   descriptor will either perform a DMA transaction to fetch input buffers and
>   write to output buffers(data descriptors), or configure the MMRs of sub blocks
>   of VPE(configuration descriptors), or provide control information to VPDMA
>   (control descriptors).
> 
> - Functions to allocate, map and unmap buffers needed for the descriptor list,
>   payloads containing MMR values and scaler coefficients. These use the DMA
>   mapping APIs to ensure exclusive access to VPDMA.
> 
> - Functions to enable VPDMA interrupts. VPDMA can trigger an interrupt on the
>   VPE interrupt line when a descriptor list is parsed completely and the DMA
>   transactions are completed. This requires masking the events in VPDMA
>   registers and configuring some top level VPE interrupt registers.
> 
> - Enable some VPDMA specific parameters: frame start event(when to start DMA for
>   a client) and line mode(whether each line fetched should be mirrored or not).
> 
> - Function to load firmware required by VPDMA. VPDMA requires a firmware for
>   it's internal list manager. We add the required request_firmware apis to fetch
>   this firmware from user space.
> 
> - Function to dump VPDMA registers.
> 
> - A function to initialize and create a VPDMA instance, this will be called by
>   the VPE driver with it's platform device pointer, this function will take care
>   of loading VPDMA firmware and returning a vpdma_data instance back to the VPE
>   driver. The VIP driver will also call the same init function to initialize it's
>   own VPDMA instance.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/ti-vpe/vpdma.c      | 578 +++++++++++++++++++++++++++++
>  drivers/media/platform/ti-vpe/vpdma.h      | 155 ++++++++
>  drivers/media/platform/ti-vpe/vpdma_priv.h | 119 ++++++
>  3 files changed, 852 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
>  create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
>  create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
> 

