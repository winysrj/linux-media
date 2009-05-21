Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56723 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZEUGN1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 02:13:27 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4L6DOGf004497
	for <linux-media@vger.kernel.org>; Thu, 21 May 2009 01:13:29 -0500
Received: from tidmzi-ftp.india.ext.ti.com (localhost [127.0.0.1])
	by dflp53.itg.ti.com (8.13.8/8.13.8) with SMTP id n4L6DMfq022011
	for <linux-media@vger.kernel.org>; Thu, 21 May 2009 01:13:23 -0500 (CDT)
Received: from symphonyindia.ti.com (symphony-ftp [192.168.247.11])
	by tidmzi-ftp.india.ext.ti.com (Postfix) with SMTP id 4D2CC3886F
	for <linux-media@vger.kernel.org>; Thu, 21 May 2009 11:40:47 +0530 (IST)
From: "chaithrika" <chaithrika@ti.com>
To: "'Chaithrika U S'" <chaithrika@ti.com>,
	<linux-media@vger.kernel.org>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>
References: <1241789126-23317-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1241789126-23317-1-git-send-email-chaithrika@ti.com>
Subject: RE: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Thu, 21 May 2009 11:42:57 +0530
Message-ID: <03fc01c9d9db$2f9f8b20$8edea160$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Do you have any review comments on this patch set?

Regards,
Chaithrika

> -----Original Message-----
> From: Chaithrika U S [mailto:chaithrika@ti.com]
> Sent: Friday, May 08, 2009 6:55 PM
> To: linux-media@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com; Manjunath Hadli;
> Brijesh Jadav; Chaithrika U S
> Subject: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display
> driver
> 
> Display driver for TI DM646x EVM
> 
> Signed-off-by: Manjunath Hadli <mrh@ti.com>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> 
> These patches add the display driver support for TI DM646x EVM.
> This patch set has been tested for basic display functionality for
> Composite and Component outputs.
> 
> This patch set consists of the updates based on the review comments by
> Hans Verkuil.
> 
> Patch 1: Display device platform and board setup
> Patch 2: VPIF driver
> Patch 3: DM646x display driver
> Patch 4: Makefile and config files modifications for Display
> 
> Some of the features like the HBI/VBI support are not yet implemented.
> Also there are some known issues in the code implementation like
> fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been
> tested extensively.
> 
> -Chaithrika



