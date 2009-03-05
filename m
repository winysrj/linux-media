Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:50831 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZCEVN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 16:13:27 -0500
Received: by bwz26 with SMTP id 26so118047bwz.37
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 13:13:25 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Mar 2009 23:13:24 +0200
Message-ID: <36c518800903051313y184cc5e7i79deb2517fef61f7@mail.gmail.com>
Subject: Is v4l2 loopback needed in kernel? Invitation for code review
From: vasaka@gmail.com
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, my v4l2 loopback device is now at working state: it can do
streaming and basic IO, works with Skype, luvcview and mplayer. next
feature planned is allowing multiply readers.
Benefits from having this driver are: video effects for video
conferencing programms aware only about v4l, driver can serve as
adapter between v4l1 and v4l2 and allow multiply readers for webcam.

Is it worth to push this driver to kernel? I have already done some
work to comply with kernel coding style, and need a code review to
make shure if I managed to follow common practicies.

current version is tested only with 2.6.26 kernel, I will add 2.6.28
support(if any work needed) soon.
code hosted on google code
http://code.google.com/p/v4l2loopback/
--
Vasily Levin
