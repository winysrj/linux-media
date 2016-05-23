Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:52051 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbcEWMoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 08:44:23 -0400
Date: Mon, 23 May 2016 13:44:16 +0100
From: Eric Engestrom <eric.engestrom@imgtec.com>
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
CC: Sumit Semwal <sumit.semwal@linaro.org>,
	"open list:DMA BUFFER SHARING FRAMEWORK"
	<linux-media@vger.kernel.org>,
	"open list:DMA BUFFER SHARING FRAMEWORK"
	<dri-devel@lists.freedesktop.org>,
	"moderated list:DMA BUFFER SHARING FRAMEWORK"
	<linaro-mm-sig@lists.linaro.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dma-buf: use vma_pages().
Message-ID: <20160523124415.GD13596@imgtec.com>
References: <1464003522-27682-1-git-send-email-falakreyaz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1464003522-27682-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 23, 2016 at 05:08:42PM +0530, Muhammad Falak R Wani wrote:
> Replace explicit computation of vma page count by a call to
> vma_pages().
> Also, include <linux/mm.h>

All good!
Reviewed-by: Eric Engestrom <eric.engestrom@imgtec.com>
