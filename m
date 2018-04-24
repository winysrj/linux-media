Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbeDXSst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 14:48:49 -0400
Date: Tue, 24 Apr 2018 20:48:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180424184843.GX4043@hirez.programming.kicks-ass.net>
References: <cover.1524499368.git.gustavo@embeddedor.com>
 <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
 <20180424093500.xvpcm3ibcu7adke2@mwanda>
 <20180424103609.GD4064@hirez.programming.kicks-ass.net>
 <20180424144755.1c2e2478@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424144755.1c2e2478@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 02:47:55PM -0300, Mauro Carvalho Chehab wrote:
> So, I'm wondering if are there any way to mitigate it inside the 
> core itself, instead of doing it on every driver, e. g. changing
> v4l_enum_fmt() implementation at v4l2-ioctl.
> 
> Ok, a "poor man" approach would be to pass the array directly to
> the core and let the implementation there to implement the array
> fetch logic, calling array_index_nospec() there, but I wonder if
> are there any other way that won't require too much code churn.

Sadly no; the whole crux is the array bound check itself. You could
maybe pass around the array size to the core code and then do something
like:

	if (f->index >= f->array_size)
		return -EINVAL;

	f->index = nospec_array_index(f->index, f->array_size);

in generic code, and have all the drivers use f->index as usual, but
even that would be quite a bit of code churn I guess.
