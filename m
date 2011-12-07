Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53599 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1LGLan (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 06:30:43 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 0093D10004C7
	for <linux-media@vger.kernel.org>; Wed,  7 Dec 2011 03:30:41 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
References: <001101ccae6d$9900b350$cb0219f0$@org>
In-Reply-To: <001101ccae6d$9900b350$cb0219f0$@org>
Subject: [dvb] Problem registering demux0 device
Date: Wed, 7 Dec 2011 13:30:45 +0200
Message-ID: <000001ccb4d3$aab157f0$001407d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm implementing new adapter for DVB, I built a module to register the
adapter and demux/net devices. From the kernel log I see all actions are
performed fine and dvb_register_device (called by dvb_dmxdev_init) is called
successfully for net0/demux0/dvr0, however, demux0/dvr0 devices do not show
up, "ls /sys/class/dvb" shows only dvb0.net0 (and nothing appears under
/dev/dvb/ anyhow).

What could cause not having demux0/dvr0 registered? Note that net0 shows up
fine.

Appreciate your help.

Thanks
Hamad

