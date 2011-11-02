Return-path: <linux-media-owner@vger.kernel.org>
Received: from old.radier.ca ([76.10.149.124]:55984 "EHLO server.radier.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755630Ab1KBOrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 10:47:31 -0400
Received: from localhost (unknown [127.0.0.1])
	by server.radier.ca (Postfix) with ESMTP id 6A4337A4AE1
	for <linux-media@vger.kernel.org>; Wed,  2 Nov 2011 10:39:40 -0400 (EDT)
Received: from server.radier.ca ([127.0.0.1])
	by localhost (server.radier.ca [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1OzvcRQswHz for <linux-media@vger.kernel.org>;
	Wed,  2 Nov 2011 10:39:38 -0400 (EDT)
Received: from server.radier.ca (server.radier.ca [76.10.144.93])
	by server.radier.ca (Postfix) with ESMTPA id 7A13C7A4ACE
	for <linux-media@vger.kernel.org>; Wed,  2 Nov 2011 10:39:38 -0400 (EDT)
From: Dmitriy Fitisov <dmitriy@radier.ca>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: KWorld USB UB435-Q v2 vid 0x1B80 pid 0xE346
Date: Wed, 2 Nov 2011 10:39:37 -0400
Message-Id: <FB79ECA9-6D75-4FEC-8938-746CDA7C5987@radier.ca>
To: linux-media <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
I have made modifications to em28xx and lgdt3305 
making it "kinda work".
I'm using scan program from dvb-apps for testing.
I'm saying "kinda work" because I cannot verify for sure, I suspect something is missing.
When I run scan it successfully locks on all channels which I have on my TV,
but cannot find PAT on most channels.
In MPEG2 stream I see that there is TS with PID 0x0000, but in most cases adaptation_field is 0,
which treated by DVB as a no payload.
Interesting enough that PUSI is set in this case.
Could not find any info on this situation, except that packets with adaptation_field == 0
must be discarded. 
I live in Toronto and this data is for CBLT channel 9 DVB-T antenna.
Windows shows everything ok.
A little bit info on the stick to help others.
It has 4 main chips on the board, em2874b, which has 2 I2C buses (guessed from em28xx source files).
First bus is connected to Atmel's AT24C32D - 32kbit flash memory with I2C address 0xA0,
second bus is connected to LGDT3305 with I2C address 0x1C, so, in order to communicate with LGDT3305
flag for secondary bus must be set (EM2874_I2C_SECONDARY_BUS_SELECT),
TDA18271HDC2 is connected through repeater of LGDT3305, so, disable_repeater field in 
lgdt configuration must not be set, and lgdt gate control should be called before starting to talk 
to TDA18271.

So, may someone provide info on PID 0000 steam packets?
Or, perhaps I'm doing something wrong and should test it in different way?

Thank you.
Dmitriy  