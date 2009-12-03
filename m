Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34084 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZLCM5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 07:57:10 -0500
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KU2009MSUNE6V@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:15 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KU200DX3UNECP@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:14 +0900 (KST)
Date: Thu, 03 Dec 2009 21:57:16 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 0/3] patches for radio-si470x-i2c driver
To: linux-media@vger.kernel.org
Cc: tobias.lorenz@gmx.net, kyungmin.park@samsung.com
Message-id: <4B17B5AC.50205@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I post patches v2 for radio-si470x-i2c driver.

[PATCH v2 1/3] radio-si470x: move some file operations to common file
[PATCH v2 2/3] radio-si470x: support RDS on si470x i2c driver
[PATCH v2 3/3] radio-si470x: support PM functions

1/3 patch is same with v1.
2/3 patch is updated the RDS interrupt enable code by review of Tobias.
3/3 patch is to support PM.

And first patch of v1 is unnecessary by 2/3 patch of v2.

Thanks.
