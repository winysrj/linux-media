Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933208AbeEYNWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 09:22:32 -0400
Date: Fri, 25 May 2018 16:21:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] media: davinci vpbe: array underflow in
 vpbe_enum_outputs()
Message-ID: <20180525132157.rx3fuvzytpsuysft@mwanda>
References: <20180525131239.45exrwgxr2f3kb57@kili.mountain>
 <a322043a-5b45-b695-4302-173c5111896b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a322043a-5b45-b695-4302-173c5111896b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 03:16:21PM +0200, Hans Verkuil wrote:
> On 25/05/18 15:12, Dan Carpenter wrote:
> > In vpbe_enum_outputs() we check if (temp_index >= cfg->num_outputs) but
> > the problem is that temp_index can be negative.  I've made
> > cgf->num_outputs unsigned to fix this issue.
> 
> Shouldn't temp_index also be made unsigned? It certainly would make a lot of
> sense to do that.

Yeah, sure.  It doesn't make any difference in terms of runtime but it's
probably cleaner.

regards,
dan carpenter
