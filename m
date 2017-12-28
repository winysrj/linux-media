Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6780 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753547AbdL1SYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 13:24:25 -0500
Date: Thu, 28 Dec 2017 20:24:20 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 2/5] media: vb2: Fix a bug about unnecessary calls to
 queue cancel and free
Message-ID: <20171228182420.ub7j3grpeff6bypl@kekkonen.localdomain>
References: <cover.1514478428.git.mchehab@s-opensource.com>
 <73a2a81d072b56ab25b36c0f40515d83ef45fccc.1514478428.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73a2a81d072b56ab25b36c0f40515d83ef45fccc.1514478428.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 28, 2017 at 02:29:35PM -0200, Mauro Carvalho Chehab wrote:
> From: Satendra Singh Thakur <satendra.t@samsung.com>
> 
> Currently, there's a logic with checks if *count is non-zero,
> q->num_buffers is zero and q->memory is different than memory.
> 
> That's flawed when the device is initialized, or after the
> queues are freed, as it does, unnecessary calls to
> __vb2_queue_cancel() and  __vb2_queue_free().
> 
> That can be avoided by making sure that q->memory is set to
> VB2_MEMORY_UNKNOWN at vb2_core_queue_init(), and adding such
> check at the loop.
> 
> [mchehab@s-opensource.com: fix checkpatch issues and improve the
>  patch, by setting q->memory to zero at vb2_core_queue_init]
> Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
