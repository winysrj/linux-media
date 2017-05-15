Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20869 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdEOK2E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 06:28:04 -0400
Date: Mon, 15 May 2017 13:27:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        David Binderman <dcb314@hotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/atomisp: putting NULs in the wrong place
Message-ID: <20170515102727.fv34r6kgkdcv7lqk@mwanda>
References: <20170515100135.guvreypnckqolnrq@mwanda>
 <59198139.9030405@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59198139.9030405@bfs.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 15, 2017 at 12:21:45PM +0200, walter harms wrote:
> can this strcpy_s() replaced with strlcpy ?
> 

These functions obviously should be removed, yes.  Please send a patch
for that and we can drop my patches.  Give David reported-by credit.

regards,
dan carpenter
