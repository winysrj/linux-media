Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:39428 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZA1Ano (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 19:43:44 -0500
Message-ID: <497FAA36.7060304@gmail.com>
Date: Wed, 28 Jan 2009 04:43:34 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: linux-media@vger.kernel.org
Subject: Re: saa716x compile warnings
References: <alpine.LSU.2.00.0901060621130.18397@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901060621130.18397@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> 
> I noticed in a forum post that the saa716x driver spews warnings on 
> x86_64:
> 
> 	http://www.linux-club.de/viewtopic.php?f=41&t=100240
> 
> /home/johnny/Documents/saa716x-e9cc5826649c/v4l/saa716x_dma.c:129: 
> warning: cast from pointer to integer of different size
> 
> as I look into the code (tip just moments ago), that seems to be largely 
> true:
> 
> 	/* align memory to page */ 
> 	dmabuf->mem_virt = (void *) PAGE_ALIGN (((u32) dmabuf->mem_virt_noalign));
> 
> I always recommend building it not only on x86 to catch such errors.
> Truncating to (u32) is likely to be wrong for 64-bit systems!
> 

Fixed now.

Thanks,
Manu

