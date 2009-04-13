Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49568 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbZDMKba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 06:31:30 -0400
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KI10009VBWG4G@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 19:31:28 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KI100AVOBWG1E@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 19:31:28 +0900 (KST)
Date: Mon, 13 Apr 2009 19:31:28 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: About the radio-si470x driver for I2C interface
In-reply-to: <200904131215.05703.tobias.lorenz@gmx.net>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: klimov.linux@gmail.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com
Message-id: <49E31480.7050100@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
 <49E29962.5010209@samsung.com> <49E2CDEA.4080409@samsung.com>
 <200904131215.05703.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm not sure about the consequences in case of renaming the radio-si470x
> module. But it would be consequent to add the appendix -usb and -i2c to
> the current name.
> 
> I applied the patch as follows:

Okay, your patch is better.
Thanks.

I will post the i2c part soon after testing.
