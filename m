Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62131 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab3F3SeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 14:34:10 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0M7WSv-1U094Q19FP-00xO5M for
 <linux-media@vger.kernel.org>; Sun, 30 Jun 2013 20:34:09 +0200
Message-ID: <51D07A27.80509@gmx.net>
Date: Sun, 30 Jun 2013 20:34:15 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: A few wiki ideas (please comment!)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a few ideas for the wiki. They go a bit further than fixing a 
typo, so I'd first like to discuss the ideas before messing up wiki 
pages and doing lots of unwanted work.

The first is to add a ==Users== section to each device, just above the 
external links section. For this I already made the following template 
to use (may need some tweaking, but it's a start):

http://www.linuxtv.org/wiki/index.php/Template:Users_who_own_this_device

The idea is primarily that whenever a patch is written for the device or 
another patch that might influence this device it's easier to find 
contact details for a few users who are willing to test the patch so 
they can be contacted directly. Most people don't read every message on 
the mailing list.

---

The second idea is a bit more complicated and I'm not even sure the wiki 
is the right place to do it. While searching for support information for 
various devices, I noticed that I kept stumbling upon abandoned patches, 
mostly on the mailing list, for devices that are currently unsupported 
in v4l-dvb. If I really start to dig in, I'm afraid I'll find at least 
tens of them. Some of those devices are really attractive.

That seems like a waste: we know how the device works, we actually have 
working code.. But for one reason or another, it's not getting pulled. 
Maybe the code needs a cleanup. Maybe somebody just forgot to file a 
pull request. Maybe the code wasn't signed off. AFAIK we currently have 
no overview of these patches.

The idea is to make a wiki page (suggestions for a page title?) that 
lists the device, links to the available patch(es) or code and lists the 
reason why the patch hasn't been pulled yet.

Best regards,

P. van Gaans
