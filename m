Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:61535 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbcEWLBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 07:01:31 -0400
Date: Mon, 23 May 2016 12:01:28 +0100
From: Eric Engestrom <eric.engestrom@imgtec.com>
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
CC: Sumit Semwal <sumit.semwal@linaro.org>,
	"moderated list:DMA BUFFER SHARING FRAMEWORK"
	<linaro-mm-sig@lists.linaro.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DMA BUFFER SHARING FRAMEWORK"
	<dri-devel@lists.freedesktop.org>,
	"open list:DMA BUFFER SHARING FRAMEWORK"
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: use vma_pages().
Message-ID: <20160523110128.GC13596@imgtec.com>
References: <1463837013-17074-1-git-send-email-falakreyaz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1463837013-17074-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 21, 2016 at 06:53:32PM +0530, Muhammad Falak R Wani wrote:
> Replace explicit computation of vma page count by a call to
> vma_pages()
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---

Good change, but this function is defined in mm.h
Please add:

    #include <linux/mm.h>

With that fixed:
Reviewed-by: Eric Engestrom <eric.engestrom@imgtec.com>
