Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:37186 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab2HEP1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 11:27:21 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-226.nexicom.net [216.168.121.226])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q75FR4Z7002164
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 11:27:10 -0400
Received: from [127.0.0.1] (unknown [IPv6:::1])
	by mail.lockie.ca (Postfix) with ESMTP id 3F5CB1E010D
	for <linux-media@vger.kernel.org>; Sun,  5 Aug 2012 11:27:04 -0400 (EDT)
Message-ID: <501E90C8.1000906@lockie.ca>
Date: Sun, 05 Aug 2012 11:27:04 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: firmware directory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[   62.739097] cx25840 6-0044: unable to open firmware v4l-cx23885-avcore-01.fw

Did the firmware directory change recently?

# ls -l /lib/firmware/v4l-cx23885-avcore-01.fw 
-rw-r--r-- 1 root root 16382 Oct 15  2011 /lib/firmware/v4l-cx23885-avcore-01.fw
