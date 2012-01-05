Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49039 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab2AEQ0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 11:26:48 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 9531410004D4
	for <linux-media@vger.kernel.org>; Thu,  5 Jan 2012 08:26:43 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
References: 
In-Reply-To: 
Subject: DVB: Question on TS_DECODER
Date: Thu, 5 Jan 2012 18:26:52 +0200
Message-ID: <000101cccbc6$d667c5f0$833751d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

dvb_dmxdev_start_feed sets TS_DECODER to ts_type regardless of whether
pes-output was set to DMX_OUT_DECODER or not, but depending on the pes-type
only. 

This might cause confusion, there's a hidden assumption that if user is not
interested to send data to decoder, the pes type must always be
DMX_PES_OTHER, which makes the API a bit un-clear to user-space.

If user-space is only interested in recording video packets for example, and
by mistake sets DMX_PES_VIDEO (because it just says the pes type which is
independent from the pes output type) then packets will make their way to
the decoder eventhough this was not the intention.

Is there any special reason to have this? 

Thanks,
Hamad

