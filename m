Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <bloch@verdurin.com>) id 1NyQyu-0005UC-QW
	for linux-dvb@linuxtv.org; Sun, 04 Apr 2010 16:39:21 +0200
Received: from 87-194-100-54.bethere.co.uk ([87.194.100.54]
	helo=shuttle.verdurin.salon)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1NyQyu-0001ns-3W; Sun, 04 Apr 2010 16:39:20 +0200
Received: from shuttle.verdurin.salon (localhost.localdomain [127.0.0.1])
	by shuttle.verdurin.salon (8.14.3/8.14.3) with ESMTP id o34EXJeX019389
	for <linux-dvb@linuxtv.org>; Sun, 4 Apr 2010 15:33:19 +0100
Received: (from adam@localhost)
	by shuttle.verdurin.salon (8.14.3/8.14.3/Submit) id o34EXJFY019387
	for linux-dvb@linuxtv.org; Sun, 4 Apr 2010 15:33:19 +0100
Date: Sun, 4 Apr 2010 15:33:19 +0100
From: Adam Huffman <bloch@verdurin.com>
To: linux-dvb@linuxtv.org
Message-ID: <20100404143319.GA27383@shuttle.verdurin.salon>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Problem tuning to BBC mux from Winter Hill
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


I've been trying to use a Freecom DVB-T USB stick.

With the latest data for the UK Winter Hill transmitter (taking account
of the switchover in December 2009), it works except for the BBC
channels:

>>> tune to:
>>> 801833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 801833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 793833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 793833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> (tuning failed)
WARNING: >>> tuning failed!!!

This is with the following tuning information:

# UK, Winter Hill
# Populated by J. Hornsby from a scan of active multiplexes
# UK, Winter Hill B Ceased broadcasting on 02 December 2009
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 770000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 778000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 801833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

I would appreciate any suggestions.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
