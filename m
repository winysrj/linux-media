Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33192 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1K2IE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 03:04:59 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 9CDAF10004D5
	for <linux-media@vger.kernel.org>; Tue, 29 Nov 2011 00:04:58 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
Subject: Support for multiple section feeds with same PIDs
Date: Tue, 29 Nov 2011 10:05:00 +0200
Message-ID: <001101ccae6d$9900b350$cb0219f0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Question on the current behavior of dvb_dmxdev_filter_start (dmxdev.c)

In case of DMXDEV_TYPE_SEC, the code restricts of having multiple sections
feeds allocated (allocate_section_feed) with same PID. From my experience,
applications might request allocating several section feeds using same PID
but with different filters (for example, in DVB standard, SDT and BAT tables
have same PID).

The current implementation only supports of having multiple filters on the
same section feed. 

Any special reason why it was implemented this way?

Thank you
Hamad

