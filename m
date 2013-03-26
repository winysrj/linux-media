Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25335 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab3CZHgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 03:36:20 -0400
Date: Tue, 26 Mar 2013 10:35:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: devel@driverdev.osuosl.org, mchehab@redhat.com,
	gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
	hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [PATCH -next] [media] go7007: fix invalid use of sizeof in
 go7007_usb_i2c_master_xfer()
Message-ID: <20130326073557.GI9138@mwanda>
References: <CAPgLHd-+DNxxVHsXiJpk2KFk8mzrQUkwaYPUFeWHyAmz-H6=4Q@mail.gmail.com>
 <20130326070415.GH9138@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326070415.GH9138@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 26, 2013 at 10:04:15AM +0300, Dan Carpenter wrote:
> On Tue, Mar 26, 2013 at 02:42:47PM +0800, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > sizeof() when applied to a pointer typed expression gives the
> > size of the pointer, not that of the pointed data.
> >
> 
> This fix isn't right.  "buf" is a char pointer.  I don't know what
> this code is doing.  Instead of sizeof(*buf) it should be something
> like "buflen", "msg[i].len", "msg[i].len + 1" or "msg[i].len + 3".

It should be "msg[i].len + 1", I think.

On the line before it writes buflen bytes to the hardware.  Then
it clears the transfer buffer and reads "msg[i].len + 1" bytes from
the hardware.  Then it saves the memory, except for the first byte,
in msg[i].buf.

So it should clear "msg[i].len + 1" bytes so that the old data isn't
confused with the data that we read from the hardware.

regards,
dan carpenter

