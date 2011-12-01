Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:35942 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1LAN5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 08:57:45 -0500
Message-ID: <4ED787D5.203@linuxtv.org>
Date: Thu, 01 Dec 2011 14:57:41 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: linux-media@vger.kernel.org
Subject: Re: Support for multiple section feeds with same PIDs
References: <001101ccae6d$9900b350$cb0219f0$@org> <4ED782E2.9060004@linuxtv.org> <000301ccb030$dfaa71f0$9eff55d0$@org>
In-Reply-To: <000301ccb030$dfaa71f0$9eff55d0$@org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.12.2011 14:55, Hamad Kadmany wrote:
> So if I understand correctly due to HW limitations back then, if in
> user-space we want to get data of two PSI tables that share the same PID, we
> could only setup one section filter with that PID and the user-space needs
> to do the extra filtering (to parse and separate the sections belonging to
> each table)?

No. dvb_demux will do the extra filtering. Userspace won't notice.

Regards,
Andreas
