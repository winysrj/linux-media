Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:37521 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760625AbZDBW0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 18:26:21 -0400
Received: from [195.7.61.29] (joburg.koala.ie [195.7.61.29])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n32MQIpZ018639
	for <linux-media@vger.kernel.org>; Thu, 2 Apr 2009 23:26:18 +0100
Message-ID: <49D53B8A.7020900@koala.ie>
Date: Thu, 02 Apr 2009 23:26:18 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: epg data grabber
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i've been hacking together a epg data grabber
taking pieces from here, there and everywhere

the basic idea is to grab data off-air and generate xmltv format xml files

the plan is to support DVB, Freesat, Sky (UK and IT) and MediaHighway1 and 2
i have the first two working and am working on the rest

is this of interest to the linuxtv.org community
i asked the xmltv people, but they are strictly perl. i do understand.

very little of this is original work of mine. just some applied google 
and a smidgen of C

i could put it up on sf.net if there is no room on linutv.org

if anyone wants the work in progress, then please let me know
it is big released under GPL 3

i want to get it out there because i'm pretty soon going to be at the 
end of my knowledge and would appreciate help

regards
--
simon
