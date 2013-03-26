Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18263 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab3CZHEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 03:04:37 -0400
Date: Tue, 26 Mar 2013 10:04:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: hans.verkuil@cisco.com, mchehab@redhat.com,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH -next] [media] go7007: fix invalid use of sizeof in
 go7007_usb_i2c_master_xfer()
Message-ID: <20130326070415.GH9138@mwanda>
References: <CAPgLHd-+DNxxVHsXiJpk2KFk8mzrQUkwaYPUFeWHyAmz-H6=4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-+DNxxVHsXiJpk2KFk8mzrQUkwaYPUFeWHyAmz-H6=4Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 26, 2013 at 02:42:47PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> sizeof() when applied to a pointer typed expression gives the
> size of the pointer, not that of the pointed data.
>

This fix isn't right.  "buf" is a char pointer.  I don't know what
this code is doing.  Instead of sizeof(*buf) it should be something
like "buflen", "msg[i].len", "msg[i].len + 1" or "msg[i].len + 3".

I'm not sure which is correct here or what it's doing, sorry.

regards,
dan carpenter

