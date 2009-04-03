Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51904 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764155AbZDCLtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 07:49:09 -0400
Received: by fxm2 with SMTP id 2so942659fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 04:49:06 -0700 (PDT)
Message-ID: <49D5F72E.4050007@gmail.com>
Date: Fri, 03 Apr 2009 14:46:54 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
CC: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	s.hauer@pengutronix.de, paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
References: <20090403113054.11098.67516.stgit@localhost.localdomain>
In-Reply-To: <20090403113054.11098.67516.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changelog since V3:
- DMA buffer size decreased to 4Mbytes
- Added pdata test in set_bus_param()

