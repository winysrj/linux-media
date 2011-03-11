Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36088 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1CKSEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 13:04:13 -0500
Received: by ywj3 with SMTP id 3so1285347ywj.19
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 10:04:13 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Mar 2011 19:04:12 +0100
Message-ID: <AANLkTik2jsKfBYjj37gXZH=h5R0DPZ5tVyXusw0Y4noi@mail.gmail.com>
Subject: What is the driver for "0c45:6413 Microdia" webcam?
From: "Chen, Xianwen" <xianwen.chen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi there,

I'm having a hard time locating the proper driver for "0c45:6413
Microdia" webcam. I consulted "Documentation/video4linux/gspca.txt",
but didn't find such a device.

Here is the lsusb output:

Bus 001 Device 003: ID 0c45:6413 Microdia
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Any hint, please?

Xianwen
