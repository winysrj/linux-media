Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb06fl.versatel.de ([89.246.255.250]:33999 "EHLO
	mxweblb06fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab0BDAfR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 19:35:17 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb06fl.versatel.de (8.13.1/8.13.1) with ESMTP id o140I7Gi013909
	for <linux-media@vger.kernel.org>; Thu, 4 Feb 2010 01:18:07 +0100
Received: from cinnamon-sage.de (i577A5883.versanet.de [87.122.88.131])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o140I7Kh030540
	for <linux-media@vger.kernel.org>; Thu, 4 Feb 2010 01:18:07 +0100
Received: from 192.168.23.2:51463 by cinnamon-sage.de for <linux-media@vger.kernel.org> ; 04.02.2010 01:18:07
Message-ID: <4B6A123F.5080500@cinnamon-sage.de>
Date: Thu, 04 Feb 2010 01:18:07 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ivtv-utils/test/ps-analyzer.cpp: error in extracting SCR?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

  I'm writing some code repacking the program stream that ivtv delivers 
into a transport stream (BTW: is there existing code for this?). Since 
many players needs the PCR I would like to use the SCR of the PS and 
place it in the adaption field of the TS (if wikipedia [1] and my 
interpretation of it is correct it should be the same).

  I stumbled upon the ps-analyzer.cpp in the test-directory of the 
ivtv-utils (1.4.0). From line 190 to 198 the SCR and SCR extension are 
extracted from the PS-header. But referring to [2] the SCR extension has 
9 bits, the highest 2 bits in the fifth byte after the sync bytes and 
the lower 7 bits in the sixth byte. The last bit is a marker bit (always 1).

  So instead of

scr_ext = (hdr[4] & 0x1) << 8;
scr_ext |= hdr[5];

  I think it should be

scr_ext = (unsigned)(hdr[4] & 0x3) << 7;
scr_ext |= (hdr[5] & 0xfe) >> 1;

  And the bitrate is coded in the next 22 bits, so it should be

mux_rate = (unsigned)(hdr[6]) << 14;
mux_rate |= (unsigned)(hdr[7]) << 6;
mux_rate |= (unsigned)(hdr[8] & 0xfc) >> 2;

  Am I correct?

Regards,
Lars.

[1] http://en.wikipedia.org/wiki/Presentation_time_stamp
[2] http://en.wikipedia.org/wiki/MPEG_program_stream
