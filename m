Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43048 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756002AbdJJIyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:54:49 -0400
Date: Tue, 10 Oct 2017 11:54:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
Message-ID: <20171010085446.n3yrr5whcv7lsbpr@valkosipuli.retiisi.org.uk>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
 <CGME20171010074231epcas5p3c2f9109c62b9e84af7f6905bb34a6ef4@epcas5p3.samsung.com>
 <dd1e2f3e-18f1-ed77-2520-aac1bea0c1a9@linaro.org>
 <8c775a5d-e42a-761b-e5ef-6dee93d7f476@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c775a5d-e42a-761b-e5ef-6dee93d7f476@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 10, 2017 at 10:01:36AM +0200, Marek Szyprowski wrote:
> Hi Stanimir,
> 
> On 2017-10-10 09:42, Stanimir Varbanov wrote:
> > Marek,
> > 
> > Any comments?
> 
> Oh, I thought that this one has been already merged. If not (yet),
> here is my ack.
> 
> > On 08/29/2017 02:26 PM, Stanimir Varbanov wrote:
> > > Currently videobuf2-dma-sg checks for dma direction for
> > > every single page and videobuf2-dc lacks any dma direction
> > > checks and calls set_page_dirty_lock unconditionally.
> > > 
> > > Thus unify and align the invocations of set_page_dirty_lock
> > > for videobuf2-dc, videobuf2-sg  memory allocators with
> > > videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
> > > copied to dc and dma-sg.
> > > 
> > > Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
