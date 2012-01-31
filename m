Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32858 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2AaJmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 04:42:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [PATCH] dma-buf: add dma_data_direction to unmap dma_buf_op
Date: Tue, 31 Jan 2012 10:42:59 +0100
Cc: dri-devel@lists.freedesktop.org, t.stanislaws@samsung.com,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
References: <1327657408-15234-1-git-send-email-sumit.semwal@ti.com> <201201301519.07785.laurent.pinchart@ideasonboard.com> <CAB2ybb8RX5Sy7-s4-X2cLC9HcoTmsn_miYu0HysjHSU4aZ4BBw@mail.gmail.com>
In-Reply-To: <CAB2ybb8RX5Sy7-s4-X2cLC9HcoTmsn_miYu0HysjHSU4aZ4BBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201311042.59917.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sumit,

> On Friday 27 January 2012 10:43:28 Sumit Semwal wrote:

[snip]

>  static inline void dma_buf_unmap_attachment(struct dma_buf_attachment
> *attach,
> -                                            struct sg_table *sg)
> +                     struct sg_table *sg, enum dma_data_direction write)

On a second thought, would it make sense to store the direction in struct 
dma_buf_attachment in dma_buf_map_attachment(), and pass the value directly to 
the .unmap_dma_buf() instead of requiring the dma_buf_unmap_attachment() 
caller to remember it ? Or is an attachment allowed to map the buffer several 
times with different directions ?

-- 
Regards,

Laurent Pinchart
