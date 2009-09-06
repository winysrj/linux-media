Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49896 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZIFHVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2009 03:21:25 -0400
Received: by bwz19 with SMTP id 19so1018534bwz.37
        for <linux-media@vger.kernel.org>; Sun, 06 Sep 2009 00:21:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ef96b78e0909052355q71f1f2ddudbc787bbffec39e1@mail.gmail.com>
References: <ef96b78e0909051137w188ef6ddw75f8c595e4498f0@mail.gmail.com>
	 <ef96b78e0909052355q71f1f2ddudbc787bbffec39e1@mail.gmail.com>
Date: Sun, 6 Sep 2009 09:21:26 +0200
Message-ID: <ef96b78e0909060021r770966f5v93d86f44bb844d4@mail.gmail.com>
Subject: Re: Hauppauge HVR 1110 : recognized but doesn't work
From: Morvan Le Meut <mlemeut@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Seems to be a mythtv issue :
user@pvr:~$ scan ./fr-lorient
scanning ./fr-lorient
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 554166000 0 2 9 3 1 0 0
initial transponder 562166000 0 2 9 3 1 0 0
initial transponder 570166000 0 2 9 3 1 0 0
initial transponder 586166000 0 2 9 3 1 0 0
initial transponder 794166000 0 2 9 3 1 0 0
initial transponder 818166000 0 2 9 3 1 0 0
>>> tune to: 554166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 554166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 562166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 562166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 570166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 570166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 586166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 586166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 794166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
Network Name 'F'
0x0000 0x0501: pmt_pid 0x006e MR5 -- TF1 HD (running)
0x0000 0x0502: pmt_pid 0x00d2 MR5 -- France 2 HD (running)
0x0000 0x0503: pmt_pid 0x0136 MR5 -- M6HD (running)
>>> tune to: 818166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR                                              ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x0000 0x0301: pmt_pid 0x0500 CNH -- CANAL+ (running)
0x0000 0x0302: pmt_pid 0x0501 CNH -- CANAL+ CINEMA (running, scrambled)
0x0000 0x0303: pmt_pid 0x0502 CNH -- CANAL+ SPORT (running)
0x0000 0x0304: pmt_pid 0x0503 CNH -- PLANETE (running, scrambled)
0x0000 0x0306: pmt_pid 0x0505 CNH -- TPS STAR (running)
0x0000 0x03f0: pmt_pid 0x050a CNH -- (null) (running)
0x0000 0x03f1: pmt_pid 0x050b CNH -- (null) (running)
Network Name 'F'
>>> tune to: -10:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_1_2:QAM_64:TRANSMIS                                              SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
__tune_to_transponder:1508: ERROR: Setting frontend parameters failed:
22 Invali                                              d argument
>>> tune to: -10:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_1_2:QAM_64:TRANSMIS                                              SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
__tune_to_transponder:1508: ERROR: Setting frontend parameters failed:
22 Invali                                              d argument
dumping lists (10 services)
Done.

i wonder why mythtv can't use that card when the scan utility can.
(yes, i checked what card the scan utility use )
