Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14499 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1LAOW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 09:22:27 -0500
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: "'Andreas Oberritter'" <obi@linuxtv.org>
Cc: <linux-media@vger.kernel.org>
References: <001101ccae6d$9900b350$cb0219f0$@org> <4ED782E2.9060004@linuxtv.org> <000301ccb030$dfaa71f0$9eff55d0$@org> <4ED787D5.203@linuxtv.org>
In-Reply-To: <4ED787D5.203@linuxtv.org>
Subject: RE: Support for multiple section feeds with same PIDs
Date: Thu, 1 Dec 2011 16:22:28 +0200
Message-ID: <000401ccb034$a8ec2ce0$fac486a0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andreas

On 01.12.2011 15:58, Andreas Oberritter wrote:

> No. dvb_demux will do the extra filtering. Userspace won't notice.

Got it now, thanks. The one downside I see to this is that the feed will be
stopped momentarily (dvb_dmxdev_feed_stop) before new filter is allocated
that have the same PID.

Regards,
Hamad

