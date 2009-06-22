Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe16.tele2.it ([212.247.155.237]:40769 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbZFVUkG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 16:40:06 -0400
Subject: Choppy audio/video with KWorld DVB-S 100...
From: Andrea Giuliano <sarkiaponius@alice.it>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Jun 2009 21:15:25 +0200
Message-Id: <1245698125.5184.6.camel@localhost>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been watching and recording free channels for almost a couple of
year with this card, using MythTV, but suddenly some weeks ago I
couldn't any more.

I thought it was a problem with the signal in my region, but it could
not be the case, since I still can watch TV perfectly fine with the same
dish and a set top box.

Also, at present MythTV says "signal 98%, s/n 4.8db", which sounds
strange.

Last but not least, femon -H gives the following output:

FE: Conexant CX24123/CX24109 (DVBS)
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  64% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  60% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  63% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  63% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  62% | ber 35 | unc 0 | 

The lines about a problem are new to me: I ran femon many many times in
the past without those lines. Please also note the completely different
value for the strength (44% vs 98% that MythTV says).

I'm afraid my card could be damaged, or something is going wrong with
driver, config or what else.

One more thing: the problems above appear with kernel 2.6.25-1, 2.6.26-1
and 2.6.2.6-2, but not with 2.6.18-1. With the latter I can record
perfectly, and femon shows a much better S/N ratio! But I've been
running 2.6.26-2 since many months ago, how could it be a kernel
problem?

What's going on?

Any hint would be much appreciated.

---
Andrea
