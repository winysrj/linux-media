Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44212 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2BLOTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 09:19:10 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 7875C10004D1
	for <linux-media@vger.kernel.org>; Sun, 12 Feb 2012 06:19:09 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
Subject: [media][dvb-core] Question on dvr device copy 
Date: Sun, 12 Feb 2012 16:19:24 +0200
Message-ID: <000001cce991$53bf56c0$fb3e0440$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Currently when playing stream from memory through dvr device (through write
calls), the written buffer is copied from user-space to kernel space. The
same applies when recording a stream, the TS packets received from HW are
copied to dvr ring-buffer.

I'm a bit concerned about the performance due to the copy, and whether we
better have a memory mapped ring-buffer in dvr device output and/or dvr
device input with user-space to cope with high bitrate streams.

Your feedback on this will be mostly appreciated.

Thanks
Hamad

