Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27334 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1LANzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 08:55:21 -0500
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: "'Andreas Oberritter'" <obi@linuxtv.org>
Cc: <linux-media@vger.kernel.org>
References: <001101ccae6d$9900b350$cb0219f0$@org> <4ED782E2.9060004@linuxtv.org>
In-Reply-To: <4ED782E2.9060004@linuxtv.org>
Subject: RE: Support for multiple section feeds with same PIDs
Date: Thu, 1 Dec 2011 15:55:21 +0200
Message-ID: <000301ccb030$dfaa71f0$9eff55d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andreas

So if I understand correctly due to HW limitations back then, if in
user-space we want to get data of two PSI tables that share the same PID, we
could only setup one section filter with that PID and the user-space needs
to do the extra filtering (to parse and separate the sections belonging to
each table)?

Regards,
Hamad

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Andreas Oberritter
Sent: Thursday, December 01, 2011 3:37 PM
To: Hamad Kadmany
Cc: linux-media@vger.kernel.org
Subject: Re: Support for multiple section feeds with same PIDs

Hello Hamad,

On 29.11.2011 09:05, Hamad Kadmany wrote:
> Question on the current behavior of dvb_dmxdev_filter_start (dmxdev.c)
> 
> In case of DMXDEV_TYPE_SEC, the code restricts of having multiple sections
> feeds allocated (allocate_section_feed) with same PID. From my experience,
> applications might request allocating several section feeds using same PID
> but with different filters (for example, in DVB standard, SDT and BAT
tables
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
http://cvs.tuxbox.org/cgi-bin/viewcvs.cgi/tuxbox/driver/dvb/drivers/media/dv
b/avia/avia_gt_napi.c?rev=1.208&view=markup

Regards,
Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

