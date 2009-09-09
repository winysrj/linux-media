Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:44772 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbZIIPNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 11:13:21 -0400
Subject: NetUP Dual DVB-T/C-CI RF PCI-E x1
From: Abylai Ospan <aospan@netup.ru>
To: linux-dvb@linuxtv.org
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Wed, 09 Sep 2009 18:51:12 +0400
Message-Id: <1252507872.29643.330.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We have designed NetUP Dual NetUP Dual DVB-T/C-CI RF PCI-E x1 card. A short
description is available in wiki - http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF 

Features:
* PCI-e x1  
* Supports two DVB-T/DVB-C transponders simultaneously
* Supports two analog audio/video channels simultaneously
* Independent descrambling of two transponders
* Hardware PID filtering

Now we have started the work on the driver for Linux. The following  components used in this card already have their code for Linux published:
* Conexant CX23885, CX25840
* Xceive XC5000 silicon TV tuner

We are working on the code for the following components:
* STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip receiver
* Altera FPGA for Common Interafce. 

We have developed FPGA firmware for CI (according to PCMCIA/en50221). Also we are doing "hardware" PID filtering. It's fast and very flexible. JTAG is used for firmware uploading into FPGA - 
this part contains "JAM player" from Altera for processing JAM STAPL Byte-Code (.jbc files).

The resulting code will be published under GPL after receiving permissions from IC vendors.

-- 
Abylai Ospan <aospan@netup.ru>
NetUP Inc.

P.S.
We will show this card at the upcoming IBC exhibition ( stand IP402 ).

