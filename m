Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbeGaT62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 15:58:28 -0400
Date: Tue, 31 Jul 2018 11:16:56 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 14/26] media: Convert entity ID allocation to new IDA API
Message-ID: <20180731181656.GB16794@bombadil.infradead.org>
References: <20180621212835.5636-1-willy@infradead.org>
 <20180621212835.5636-15-willy@infradead.org>
 <20180724110507.idyjc3vbbivwbxtb@valkosipuli.retiisi.org.uk>
 <20180730115521.23f7afa9@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730115521.23f7afa9@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 30, 2018 at 11:55:21AM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 24 Jul 2018 14:05:07 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > On Thu, Jun 21, 2018 at 02:28:23PM -0700, Matthew Wilcox wrote:
> > > Removes a call to ida_pre_get().
> > > 
> > > Signed-off-by: Matthew Wilcox <willy@infradead.org>  
> > 
> > Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I'm assuming that the entire series will be applied together via some
> other tree. So:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Yep, thanks.  It's in linux-next and it's all going in via my 'ida'
branch.
