Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2719 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3LMM1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 07:27:07 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBDCR4Dp050015
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 13:27:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8ABE02A2224
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 13:26:54 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/4] add radio-raremono driver
Date: Fri, 13 Dec 2013 13:26:45 +0100
Message-Id: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the new radio-raremono driver for the USB
'Thanko's Raremono' AM/FM/SW receiver.

Since it (ab)uses the same USB IDs as the si470x SiLabs Reference
Design I had to add additional checks to si470x to tell the two apart.

While editing si470x I noticed that it passes USB buffers from the stack
instead of using kmalloc, so I fixed that as well.

I have tested the si470x checks, and the FM and AM receiver of the
Raremono device have been tested as well. I don't have a SW transmitter,
nor are there any SW transmitters here in Norway, so I couldn't test it.

All I can say is that it is definitely tuning since the white noise
changes when I change frequency. I'll try this nexy week in the Netherlands,
as I think there are still a few SW transmissions there I might receive.

The initial reverse engineering for this driver was done by Dinesh Ram
as part of his Cisco internship, so many thanks to Dinesh for doing that
work.

Regards,

	Hans

