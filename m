Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29353 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbcITIpf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 04:45:35 -0400
Date: Tue, 20 Sep 2016 11:45:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ravikant Sharma <ravikant.s2@samsung.com>,
        vidushi.koul@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: Staging: Media: Lirc - Fix possible ERR_PTR() dereferencing.
Message-ID: <20160920084510.GG13620@mwanda>
References: <1474354281-18962-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474354281-18962-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 20, 2016 at 12:21:21PM +0530, Shailendra Verma wrote:
> This is of course wrong to call kfree() if memdup_user() fails,
> no memory was allocated and the error in the error-valued pointer
> should be returned.
> 
> Reviewed-by: Ravikant Sharma <ravikant.s2@samsung.com>
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Calling kfree(NULL) is fine so there is no bug in the original code.
Also this patch creates a new locking bug.

regards,
dan carpenter

