Return-path: <linux-media-owner@vger.kernel.org>
Received: from shakira.uii.net.id ([202.162.32.10]:36346 "EHLO
	aegis.uii.net.id" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1KNBCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 20:02:10 -0500
Received: from [124.40.249.82] (helo=[192.168.10.232])
	by aegis.uii.net.id with esmtpa (Exim 4.69)
	(envelope-from <bino@indoakses-online.com>)
	id 1RPkV9-0006tz-Uj
	for linux-media@vger.kernel.org; Mon, 14 Nov 2011 07:34:20 +0700
Message-ID: <4EC0620D.1020308@indoakses-online.com>
Date: Mon, 14 Nov 2011 07:34:21 +0700
From: bino oetomo <bino@indoakses-online.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: is this doable ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Dear All.

I'm seeking for a way to do low-cost but easy-to-do NOAA APT receiving.
Since NOAA APT Requency band is at arround 136-138 Mhz many people build 
their receiver based on TV tuner.
Based on this fact, I think a PCI/USB TV receiver card will do.

I start by looking what card is available in my area, and I found it's 
"LEADTEK TV2000 XP Global - TV / FM Tuner", and
from http://istvanv.users.sourceforge.net/v4l/xc4000.html , I got that 
the tuner module will be XC3028 or XC4100
With this , I try to search for datasheet, and from XCeive.inc site .. I 
got that this tuner's frequency range is betwen 42-864 Mhz.

Next I look what linuxtv said about that two tuner :
1. For XC3028 --> http://linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028
2. For XC4100 , I got http://tw1965.myweb.hinet.net/Linux.htm and then 
http://tw1965.myweb.hinet.net/Linux.htm

So I think the driver things will doable.

But AFAIK , NOAA APT signals is just a plain FM signals.
How to set this card to receive FM in frequency ranges of 136-138 Mhz ?
will this ( http://linux.die.net/man/1/fm ) can do the job ?
How can I set the FM frequency bandwidth to 40kHz - 50kHz (Standar FM 
Broadcast is 150 khz .. way to wide)

My plan is just record the sound using ffmpeg, and do post processing 
using other software later.

Sincerely
-bino-

