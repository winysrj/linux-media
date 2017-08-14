Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:57015 "EHLO
        v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752976AbdHNLki (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 07:40:38 -0400
To: linux-media@vger.kernel.org
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Subject: si2168 b40 and lack of auto plp
Cc: torbjorn.jansson@mbox200.swipnet.se
Message-ID: <9b29c34a-093c-9df0-6ca0-c6ddac87c6d9@mbox200.swipnet.se>
Date: Mon, 14 Aug 2017 13:41:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

a few questions
is there any card out there with a si2168 b40 in a country that uses plp!=0 
that dvb-t2 actually works for?
i suspect the answer to this is no and that it is broken on all cards.

auto plp appears broken anyway on my ct2-4650 with si2168 b40 and has been 
broken for a long time.



i have done a number of things to try to figure out whats going on.
first i have extracted the firmware for si2168 b40 used by the windows driver 
and this matches exactly with:
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.25/dvb-demod-si2168-b40-01.fw
which is the one i use on my linux box, so firmware should theoretically be ok.

then i used debugfs to turn on the extra debugging in si2168, i was mainly 
interested in verifying what plp the scanning software actually sent to the 
driver (si2168_set_frontend)

i then found out that both dvbv5-scan and w_scan both appear to use 
stream_id=0, i then made a quick and dirty hack to w_scan so it always sets plp 
id to 1 instead of 0 and this resulted for the first time in a lock on a dvb-t2 mux

so problem i have with this card appears to be the lack of auto plp and also 
the fact that all scanning programs i have tried so far doesn't really know how 
to handle plp by themselves and expect driver to do the right thing.


i assume this is a problem that is best fixed in the driver? right?
or is the software using the dvb card expected to somehow figure out plp and 
sett it correctly?

is there a way to dump what commands the windows driver is sending? if so 
perhaps something could be figured out how it sets plp.


(please keep me on CC when replying to list so i don't miss it)
