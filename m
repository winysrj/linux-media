Return-path: <mchehab@pedra>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50183 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0KPTaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 14:30:05 -0500
Received: from SHUZHENW (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 0E0A110004D5
	for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 11:29:58 -0800 (PST)
From: "Shuzhen Wang" <shuzhenw@codeaurora.org>
To: <linux-media@vger.kernel.org>
Subject: Question about setting V4L2_CID_AUTO_WHITE_BALANCE control to FALSE
Date: Tue, 16 Nov 2010 11:29:32 -0800
Message-ID: <000001cb85c4$981fdba0$c85f92e0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, 

When I set V4L2_CID_AUTO_WHITE_BALANCE control to FALSE, which one of the
following is the expected behavior?

1. Hold the current white balance settting.
2. Set the white balance to whatever V4L2_CID_WHITE_BALANCE_TEMPERATURE
control is set to.

The V4L2 API spec doesn't specify this clearly.


Regards,
-Shuzhen

