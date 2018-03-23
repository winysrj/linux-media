Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbeCWMEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:04:06 -0400
Date: Fri, 23 Mar 2018 15:03:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 02/30] media: imx-media-utils: fix a warning
Message-ID: <20180323120331.bpvkarrrv7s3dwhk@mwanda>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
 <a23deac60a8683895543c8f335c36e475948716f.1521806166.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a23deac60a8683895543c8f335c36e475948716f.1521806166.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 07:56:48AM -0400, Mauro Carvalho Chehab wrote:
> The logic at find_format() is a little bit confusing even for
> humans, and it tricks static code analyzers:
> 
> 	drivers/staging/media/imx/imx-media-utils.c:259 find_format() error: buffer overflow 'array' 14 <= 20

It's always good to simplify the code, but I have a fix for this that I
will publish very soon.

regards,
dan carpenter
