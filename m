Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37182 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeDXLVl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 07:21:41 -0400
Date: Tue, 24 Apr 2018 13:21:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180424112129.GT4129@hirez.programming.kicks-ass.net>
References: <cover.1524499368.git.gustavo@embeddedor.com>
 <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
 <20180424093500.xvpcm3ibcu7adke2@mwanda>
 <20180424103609.GD4064@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424103609.GD4064@hirez.programming.kicks-ass.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 12:36:09PM +0200, Peter Zijlstra wrote:
> 
> Then usespace probes which part of the descr[] array is now in cache and
> from that it can infer the initial out-of-bound value.

Just had a better look at v4l_fill_fmtdesc() and actually read the
comment. The code cannot be compiled as a array because it is big and
sparse. But the log(n) condition tree is a prime candidate for the
branchscope side-channel, which would be able to reconstruct a
significant number of bits of the original value. A denser tree gives
more bits etc.
