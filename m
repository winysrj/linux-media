Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:60624 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab2HDPwW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 11:52:22 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-135.nexicom.net [216.168.121.135])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q74FqLW2000558
	for <linux-media@vger.kernel.org>; Sat, 4 Aug 2012 11:52:22 -0400
Received: from [127.0.0.1] (unknown [IPv6:::1])
	by mail.lockie.ca (Postfix) with ESMTP id 1FDEE1E002B
	for <linux-media@vger.kernel.org>; Sat,  4 Aug 2012 11:52:21 -0400 (EDT)
Message-ID: <501D4535.8080404@lockie.ca>
Date: Sat, 04 Aug 2012 11:52:21 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: boot slow down
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a big pause before the 'unable'

[    2.243856] usb 4-1: Manufacturer: Logitech
[   62.739097] cx25840 6-0044: unable to open firmware v4l-cx23885-avcore-01.fw


I have a cx23885
cx23885[0]: registered device video0 [v4l2]

Is there any way to stop it from trying to load the firmware?
What is the firmware for, analog tv? Digital works fine and analog is useless to me.
I assume it is timing out there.
