Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25728 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756288AbcJYIlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 04:41:02 -0400
Date: Tue, 25 Oct 2016 11:40:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rafael =?iso-8859-1?Q?Louren=E7o?= de Lima Chehab
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] au0828-video: Use kcalloc() in
 au0828_init_isoc()
Message-ID: <20161025084031.GF4469@mwanda>
References: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
 <68ad1aaa-c029-04b9-805a-e859f6c2d2d5@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68ad1aaa-c029-04b9-805a-e859f6c2d2d5@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 24, 2016 at 10:59:24PM +0200, SF Markus Elfring wrote:
> +	dev->isoc_ctl.transfer_buffer = kcalloc(num_bufs,
> +						sizeof(*dev->isoc_ctl
> +						       .transfer_buffer),

This is ugly.

regards,
dan carpenter

