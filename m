Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:15765 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZDMB4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 21:56:24 -0400
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KI0003ZGNKY5H@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 10:46:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KI0007YBNKYBU@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 10:46:10 +0900 (KST)
Date: Mon, 13 Apr 2009 10:46:10 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: About the radio-si470x driver for I2C interface
In-reply-to: <200904122256.12305.tobias.lorenz@gmx.net>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: klimov.linux@gmail.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com
Message-id: <49E29962.5010209@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
 <4e1455be0904011754l2c51cf2fi6336d07d591cbb71@mail.gmail.com>
 <49D4180B.4040805@samsung.com> <200904122256.12305.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4/13/2009 5:56 AM, Tobias Lorenz wrote:
> Hi Joonyoung,
> 
> Hi Alexey,
> 
> I've split the driver into a couple of segments:
> 
> - radio-si470x-common.c is for common functions
> 
> - radio-si470x-usb.c are the usb support functions
> 
> - radio-si470x-i2c.c is an untested prototyped file for your i2c support
> functions
> 
> - radio-si470x.h is a header file with everything required by the c-files
> 
> I hope this is a basis we can start on with i2c support. What do you think?
> 
> The URL is:
> 
> http://linuxtv.org/hg/~tlorenz/v4l-dvb

It looks good, i will test with implementing the i2c functions.

Thanks.
