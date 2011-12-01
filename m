Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:42967 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1LANgi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 08:36:38 -0500
Message-ID: <4ED782E2.9060004@linuxtv.org>
Date: Thu, 01 Dec 2011 14:36:34 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Support for multiple section feeds with same PIDs
References: <001101ccae6d$9900b350$cb0219f0$@org>
In-Reply-To: <001101ccae6d$9900b350$cb0219f0$@org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hamad,

On 29.11.2011 09:05, Hamad Kadmany wrote:
> Question on the current behavior of dvb_dmxdev_filter_start (dmxdev.c)
> 
> In case of DMXDEV_TYPE_SEC, the code restricts of having multiple sections
> feeds allocated (allocate_section_feed) with same PID. From my experience,
> applications might request allocating several section feeds using same PID
> but with different filters (for example, in DVB standard, SDT and BAT tables
> have same PID).
> 
> The current implementation only supports of having multiple filters on the
> same section feed. 
> 
> Any special reason why it was implemented this way?

AFAIR, if you created more than one PID filter on the same PID, only one
filter would see data on most or all hardware back then. So if you have
multiple filters on the same PID, then the real filter you're setting
should be a merged version of those filters. If you use dvb_demux, it
will do the necessary post-processing for you.

This driver implements section filtering:
http://cvs.tuxbox.org/cgi-bin/viewcvs.cgi/tuxbox/driver/dvb/drivers/media/dvb/avia/avia_gt_napi.c?rev=1.208&view=markup

Regards,
Andreas
