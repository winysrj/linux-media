Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbeC0G3H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 02:29:07 -0400
Date: Tue, 27 Mar 2018 08:29:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ji-Hun Kim <ji_hun.kim@samsung.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.yadav.cs@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] staging: media: davinci_vpfe: add error handling
 on kmalloc failure
Message-ID: <20180327062904.GA29640@kroah.com>
References: <CGME20180321043915epcas1p3955f5a57c6728cd1f386f805879fc3f2@epcas1p3.samsung.com>
 <1521607150-31307-1-git-send-email-ji_hun.kim@samsung.com>
 <20180327050045.GA12754@ubuntu>
 <20180327052058.xphi47mnnbtjl2fc@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327052058.xphi47mnnbtjl2fc@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 27, 2018 at 08:20:59AM +0300, Dan Carpenter wrote:
> On Tue, Mar 27, 2018 at 02:00:45PM +0900, Ji-Hun Kim wrote:
> > 
> > Are there any opinions? I'd like to know how this patch is going.
> > 
> 
> 
> Looks good.  Thanks!
> 
> Greg just hasn't gotten to it yet.

Greg does not take drivers/staging/media/* patches :)
