Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56511 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaAGGmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 01:42:19 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so19558627pab.22
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 22:42:17 -0800 (PST)
Message-ID: <52CBA1C3.3000105@gmail.com>
Date: Tue, 07 Jan 2014 17:42:11 +1100
From: Philip Yarra <philip.yarra@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: oliver@schinagl.nl
Subject: Initial scan table for au-Melbourne-Selby
Content-Type: multipart/mixed;
 boundary="------------060900050403080904090101"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060900050403080904090101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, please find attached a scan table for au-Melbourne-Selby. This file 
is very similar to the scan table file for au-Melbourne-Upwey (which I 
was able to use until quite recently). However the fec_hi value of "2/3" 
for SBS no longer works for me, and I need to use "AUTO" instead. I 
don't know if this change also affects the Upwey repeater.

Details on the geographic locations of these repeaters can be found here:
Upwey: http://www20.sbs.com.au/transmissions/index.php?pid=2&id=795
Selby: http://www20.sbs.com.au/transmissions/index.php?pid=2&id=792

Note that the Selby repeater actually covers the parts of Upwey which 
are not able to get signal from the Upwey repeater, due to hilly 
terrain. Although they use identical frequencies, the polarisation is 
different.

I assume AUTO allows the DVB tuner to choose one of the FEC types 
dynamically, though I don't know if this is supported by all tuners. If 
there's a way I can find out which actual fec_hi is in use, please let 
me know and I will supply it.

I have provided a brief write-up at 
http://pyarra.blogspot.com.au/2014/01/mythtv-and-sbs-in-dandenong-ranges.html 
- please let me know if there is further information I can provide.

Regards,
Philip.

--------------060900050403080904090101
Content-Type: text/plain; charset=UTF-8;
 name="au-Melbourne-Selby"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="au-Melbourne-Selby"

# Australia / Melbourne (Selby Repeater)
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# ABC
T 662500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Seven
T 620500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Nine
T 641500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Ten
T 711500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# SBS
T 683500000 7MHz AUTO NONE QAM64 8k 1/8 NONE


--------------060900050403080904090101--
