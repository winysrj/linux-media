Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:52537 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbZGDH2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 03:28:04 -0400
Message-ID: <4A4F0486.8040601@adelaide.edu.au>
Date: Sat, 04 Jul 2009 16:58:06 +0930
From: Ian W Roberts <ian.w.roberts@adelaide.edu.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Adelaide Foothills DVB-T tuning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Linux Media people,

I've struggled to tune various DVB-T devices in Mitcham South Australia. 
Mitcham is in the foothills area of Adelaide without a clear line of 
sight to the main Mt Lofty transmission towers. The tuning wizards, for 
instance in me-tv, only display a single location file for Adelaide 
(au-Adelaide). There is an alternative transmitter in the Adelaide CBD 
(Grenfell Street) to cover this area.

I did quite a bit of web searching looking for information about tuning 
in this area without much success and no clear statement how to get 
DVB-T devices tuned here.

Guessing that my problem was due to the lack of tuning information for 
the Grenfell Street transmitter I created a new file 
/usr/share/dvb/dvb-t/au-AdelaideFoothills with the following data. I 
have been able to tune the 18 stations currently broadcast using the 
standard me-tv tuning wizard. :-) I'm not sure that all the data in that 
file is optimal but it works! Does anybody have any improvements to suggest.

------------------------------------------------------------------------
# Australia / Adelaide / Grenfell Street
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# ABC
T 781625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Seven
T 711500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Nine
T 795500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Ten
T 732500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# SBS
T 760500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
------------------------------------------------------------------------

It would be good if an entry equivalent to my au-AdelaideFoothills could 
be included in the linux-tv packages so that residents in the Adelaide 
foothills would have an easier experience with DVB-T. How can that data 
be included? Who is in a position to incorporate the additional location 
entry.

bye

ian

