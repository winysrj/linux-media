Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64614 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaAHL67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:58:59 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ20012BZY8QG00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 11:58:56 +0000 (GMT)
Message-id: <52CD3D6B.9000400@samsung.com>
Date: Wed, 08 Jan 2014 12:58:35 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] Add driver for Samsung S5K5BAF camera sensor
References: <20140108095840.GA10979@elgon.mountain>
In-reply-to: <20140108095840.GA10979@elgon.mountain>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2014 10:58 AM, Dan Carpenter wrote:
> Hello Andrzej Hajda,
> 
> The patch 7d459937dc09: "[media] Add driver for Samsung S5K5BAF
> camera sensor" from Dec 5, 2013, leads to the following
> static checker warning:
> 
> 	drivers/media/i2c/s5k5baf.c:1043 s5k5baf_set_power()
> 	warn: add some parenthesis here?
> 
> drivers/media/i2c/s5k5baf.c
>   1036  static int s5k5baf_set_power(struct v4l2_subdev *sd, int on)
>   1037  {
>   1038          struct s5k5baf *state = to_s5k5baf(sd);
>   1039          int ret = 0;
>   1040  
>   1041          mutex_lock(&state->lock);
>   1042  
>   1043          if (!on != state->power)
>                     ^^^^^^^^^^^^^^^^^^^
> This would be cleaner if it were "if (on == state->power)"

This version works correctly only for 'on' equal 0 and 1, my version
works for all ints. On the other side documentation says only 0 and 1 is
allowed for s_power callbacks :)
I would stay with my version, similar approach is in other drivers.

Regards
Andrzej

> 
>   1044                  goto out;
>   1045  
>   1046          if (on) {
> 
> regards,
> dan carpenter
> 

