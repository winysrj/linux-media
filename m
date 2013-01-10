Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3AJKmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 05:42:55 -0500
Received: from HKADMANY (pdmz-ns-snip_218_1.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 6955A10004B7
	for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 02:42:53 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
Subject: [dvb] Question on dvb-core re-structure
Date: Thu, 10 Jan 2013 12:44:14 +0200
Message-ID: <000801cdef1f$70667580$51336080$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

With the new structure of dvb-core (moved up one directory), previous
DVB/ATSC adapters were moved to media/usb, media/pci and media/mmc.

For SoC that supports integrated DVB functionality, where should the
adapter's code be located in the new structure? I don't see it fit any of
the above three options.

Thanks,

--
Hamad Kadmany,
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by
The Linux Foundation

