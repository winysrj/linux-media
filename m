Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <biribi@free.fr>) id 1OEoLR-0004eV-L4
	for linux-dvb@linuxtv.org; Wed, 19 May 2010 20:50:18 +0200
Received: from smtp2e.orange.fr ([80.12.242.113])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OEoLR-0004Lo-3c; Wed, 19 May 2010 20:50:17 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2e21.orange.fr (SMTP Server) with ESMTP id 3A2ED800075D
	for <linux-dvb@linuxtv.org>; Wed, 19 May 2010 20:50:16 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2e21.orange.fr (SMTP Server) with ESMTP id 2D4038000765
	for <linux-dvb@linuxtv.org>; Wed, 19 May 2010 20:50:16 +0200 (CEST)
Received: from [192.168.1.102] (ANantes-156-1-87-128.w90-12.abo.wanadoo.fr
	[90.12.170.128])
	by mwinf2e21.orange.fr (SMTP Server) with ESMTP id 0315D800075D
	for <linux-dvb@linuxtv.org>; Wed, 19 May 2010 20:50:15 +0200 (CEST)
Message-ID: <4BF432E7.2000203@free.fr>
Date: Wed, 19 May 2010 20:50:15 +0200
From: Damien Bally <biribi@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4BF290A2.1020904@free.fr>
In-Reply-To: <4BF290A2.1020904@free.fr>
Subject: Re: [linux-dvb] new DVB-T initial tuning for fr-nantes
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

Hi all

There's also a new transponder called L8 today on channel 56 (QAM16) for
local TV, so the fr-Nantes should look like this :

# Nantes - France
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 682000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 490000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 546000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 738000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 658000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 538000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 754000000 8MHz AUTO NONE QAM16 8k AUTO NONE



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
