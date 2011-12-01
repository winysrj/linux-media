Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62249 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1LAGXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 01:23:48 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 6E6BC10004D5
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 22:23:47 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
References: <001101ccae6d$9900b350$cb0219f0$@org>
In-Reply-To: <001101ccae6d$9900b350$cb0219f0$@org>
Subject: RE: Support for multiple section feeds with same PIDs
Date: Thu, 1 Dec 2011 08:23:47 +0200
Message-ID: <000001ccaff1$cb1cc060$61564120$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry to repeat the question, anyone has an idea on this? I appreciate your
feedback.

Thank you
Hamad

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Hamad Kadmany
Sent: Tuesday, November 29, 2011 10:05 AM
To: linux-media@vger.kernel.org
Subject: Support for multiple section feeds with same PIDs

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

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

