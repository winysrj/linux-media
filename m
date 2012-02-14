Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25751 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2BNHdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 02:33:36 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 5CAB810004D8
	for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 23:33:35 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
References: <000001cce991$53bf56c0$fb3e0440$@codeaurora.org>
In-Reply-To: <000001cce991$53bf56c0$fb3e0440$@codeaurora.org>
Subject: RE: [media][dvb-core] Question on dvr device copy 
Date: Tue, 14 Feb 2012 09:33:50 +0200
Message-ID: <000001cceaeb$00985860$01c90920$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I would appreciate if anyone can feedback on this, I'm considering
implementing mmap in demux/dvr devices so that user-space can access the
input/output buffers directly without the need for read/write operations.

Thanks
Hamad

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Hamad Kadmany
Sent: Sunday, February 12, 2012 4:19 PM
To: linux-media@vger.kernel.org
Subject: [media][dvb-core] Question on dvr device copy 

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

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

