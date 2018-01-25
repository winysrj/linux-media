Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbeAYNLS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 08:11:18 -0500
Date: Thu, 25 Jan 2018 16:10:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [bug report] [media] s5p-mfc: use MFC_BUF_FLAG_EOS to identify
 last buffers in decoder capture queue
Message-ID: <20180125131056.2wenwwmioztsylot@mwanda>
References: <CGME20180123083259epcas3p1fb9a8b4e4ad34eb245fca67d4204cba4@epcas3p1.samsung.com>
 <20180123083245.GA10091@mwanda>
 <e30dedbc-68bc-fae8-ffb7-5cdea05f534d@samsung.com>
 <20180125122522.vdly5ketvkugq53h@mwanda>
 <b89f9cc1-8101-b7cb-6130-87facd37e404@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b89f9cc1-8101-b7cb-6130-87facd37e404@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 25, 2018 at 01:31:36PM +0100, Hans Verkuil wrote:
> > Ah...  Hm.  Is it the call to vb2_core_dqbuf() which limits buf->index?
> > I don't see a path from vb2_core_dqbuf() to vb2_qbuf() but I may have
> > missed it.
> 
> The __fill_v4l2_buffer() function in videobuf2-v4l2.c is called by vb2_core_dqbuf().
> And that __fill_v4l2_buffer() overwrited the index field: b->index = vb->index;
> 
> So after the vb2_dqbuf call the buf->index field is correct and bounded.
> 

Ah..  I get it.  Thanks.

regards,
dan carpenter
