Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37984 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754200AbeE2GUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 02:20:32 -0400
Date: Mon, 28 May 2018 23:20:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] media: dvb: get rid of VIDEO_SET_SPU_PALETTE
Message-ID: <20180529062031.GA1009@infradead.org>
References: <c1e86dc99d811e90d11181b2bf2e1237db76a5c1.1527517459.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1e86dc99d811e90d11181b2bf2e1237db76a5c1.1527517459.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 11:32:41AM -0300, Mauro Carvalho Chehab wrote:
> No upstream drivers use it. It doesn't make any sense to have
> a compat32 code for something that nobody uses upstream.
> 
> Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
