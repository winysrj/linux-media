Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:34732 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab1KCJQa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 05:16:30 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9148720A
	for <linux-media@vger.kernel.org>; Thu,  3 Nov 2011 09:16:28 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas4.st.com [10.75.90.69])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 410351F4D
	for <linux-media@vger.kernel.org>; Thu,  3 Nov 2011 09:16:28 +0000 (GMT)
From: Alain VOLMAT <alain.volmat@st.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 3 Nov 2011 10:16:25 +0100
Subject: MediaController support in LinuxDVB demux
Message-ID: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Last week we started the discussion about having a MediaController aware LinuxDVB demux and I would like to proceed on this discussion.
Then, the discussion rapidly moved to having the requirement for dynamic pads in order to be able to add / remove then in the same way as demux filters are created for each open of the demux device node.

I am not really sure dynamic pads is really a MUST for MC aware demux device. The demux entity could work with a predefined number of output pads, determined by the vendor, depending on the demux capacity of the device.
Of course it is probably better to have only pads when needed but it requires quite a lot of change to the overall MC framework and such modification could be done afterward, when the MC support for LinuxDVB is much better understood.

During last workshop, I think we agreed that a pad would represent a demux filter. 
My personal idea would be to have filters created via the demux device node and filters accessible via MC pads totally independent. 
Meaning that, just as current demux, it is possible to open the demux device node, create filter, set PIDs etc. Those filters have totally no relation with MC pads, filters created via the demux device node are just not accessible via MC pads.
As far as demux MC pads are concerned, it would be possible to link a pad to another entity pad (probably decoder or LinuxDVB CA) and thus create a new filter in the demux. By setting the demux MC pad format (not sure format is the proper term here), it would be possible to set for example the PID of a filter.
Internally of course all filters (MC filters and demux device node filters) are all together but they are only accessible via either the demux device node or the MC pad.

What are your thoughts about that ?

Regards,

Alain
