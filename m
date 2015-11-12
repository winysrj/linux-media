Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34043 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbKLGyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 01:54:18 -0500
Received: by igvg19 with SMTP id g19so8864330igv.1
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2015 22:54:17 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Nov 2015 08:54:17 +0200
Message-ID: <CAJ2oMhL3VT=b_u=MQcymxDdxRB+bCn8ozaWW7vMh2HFPuKdmvQ@mail.gmail.com>
Subject: v4l vs. dpdk
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I hope you can assist me on the following debate.

I need to develop a driver/application which capture and output video
frames from PCIe device , and is using Intel cpu (i7), and Intel's
media sdk server framework for the video compression.

I am not sure what will be a better choice between the following 2 options:
1. application which use dpdk for capture and output to the PCIe device
2. v4l driver for the PCIe device

Intel advocate the usage of dpdk (framework for packet processing).
dpdk is supposed to be able to read/write from PCIe device too.
I tried to see the prons/cons of dpdk compared to v4l.

prons of dpdk, as I understand them:
1. userspace application (easier debugging compared to kernel
debugging of v4l device driver)
2. supposed better performance

cons of dpdk compared to v4l:
1. I could not find examples for PCIe device usage , or samples for
showing how application (such as media sdk) use dpdk video frames.


Thank you for any feedback on the matter,

Regards,
Ran
