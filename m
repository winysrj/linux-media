Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18514 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaAHMYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 07:24:20 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ300LK314IT900@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 12:24:18 +0000 (GMT)
Message-id: <52CD435B.7060900@samsung.com>
Date: Wed, 08 Jan 2014 13:23:55 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [kbuild-all] [linuxtv-media:master 499/499]
 drivers/media/i2c/s5k5baf.c:362:3: warning: format '%d' expects argument of
 type 'int', but argument 3 has type 'size_t'
References: <52b94458.53lWHr3FG9kOLNn4%fengguang.wu@intel.com>
 <20140108083736.GA27840@mwanda>
In-reply-to: <20140108083736.GA27840@mwanda>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2014 09:37 AM, Dan Carpenter wrote:
> The other thing that concerned me with this was the sparse warning:
> 
> drivers/media/i2c/s5k5baf.c:481:26: error: bad constant expression
> 
> It was hard to verify that this couldn't go over 512.  I guess 512 is
> what we would consider an error in this context.  This seems like it
> could be determined by the firmware?

Thanks for reporting.

I will prepare patch adding check for this.

Regards
Andrzej

> 
> regards,
> dan carpenter
> 

