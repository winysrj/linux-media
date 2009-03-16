Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:30160 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZCPNDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 09:03:40 -0400
Received: by an-out-0708.google.com with SMTP id c2so18621anc.1
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 06:03:38 -0700 (PDT)
Subject: Re: [linux-dvb] EC168 and MT2060
From: "t.Hgch" <pureherz@gmail.com>
Reply-To: pureherz@gmail.com
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <49BD5D0E.3090304@iki.fi>
References: <1237129041.7993.38.camel@0ri0n>  <49BD3B31.8030308@iki.fi>
	 <1237146464.7993.94.camel@0ri0n>  <49BD5D0E.3090304@iki.fi>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 14:03:33 +0100
Message-Id: <1237208613.8685.13.camel@0ri0n>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I opened de device and it is definitely an EC168 and a MXL5003s, also to
my surprise on the chipset it is written DUTV007 instead of DUTV002,
which was the model number that was written in the package.

However when scanning I get errors and only finds about a third of
available services at best.

$ scan -n -5 /usr/share/dvb/dvb-t/es-Madrid  
scanning /usr/share/dvb/dvb-t/es-Madrid
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 618000000 0 2 9 3 1 3 0
initial transponder 706000000 0 2 9 3 1 3 0
initial transponder 770000000 0 2 9 3 1 3 0
initial transponder 810000000 0 2 9 3 1 3 0
initial transponder 834000000 0 2 9 3 1 3 0
initial transponder 842000000 0 2 9 3 1 3 0
initial transponder 850000000 0 2 9 3 1 3 0
initial transponder 858000000 0 2 9 3 1 3 0
>>> tune to:
618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
Network Name 'Teledifusion Madrid'
0x0027 0x0f3d: pmt_pid 0x0000 Teledifusion Madrid -- 8madrid (running)
0x0027 0x0f3e: pmt_pid 0x0000 Teledifusion Madrid -- Popular TV MADRID
(running)
0x0027 0x0f3f: pmt_pid 0x0000 Teledifusion Madrid -- Tribunal TV
(running)
0x0027 0x0f40: pmt_pid 0x0000 Teledifusion Madrid -- Kiss TV (running)
0x0027 0x0f41: pmt_pid 0x0000 Teledifusion Madrid -- COPE (running)
WARNING: filter timeout pid 0x0010
>>> tune to:
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
Network Name 'Teledifusion Madrid'
0x0032 0x1389: pmt_pid 0x0110 Teledifusion Madrid -- Aprende Ingles TV
(running)
0x0032 0x138a: pmt_pid 0x0210 Teledifusion Madrid -- Libertad Digital TV
(running)
0x0032 0x138b: pmt_pid 0x0310 Teledifusion Madrid -- Ver-T (running)
0x0032 0x138c: pmt_pid 0x0410 Teledifusion Madrid -- esMADRIDtv
(running)
0x0032 0x138d: pmt_pid 0x0510 Teledifusion Madrid -- Radio MARCA
(running)
WARNING: filter timeout pid 0x0010
>>> tune to:
770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
0x0000 0x0212: pmt_pid 0x0064 RTVE -- La 1 (running)
0x0000 0x0213: pmt_pid 0x00c8 RTVE -- La 2 (running)
0x0000 0x0214: pmt_pid 0x03e8 RTVE -- 24h (running)
0x0000 0x0215: pmt_pid 0x05dc RTVE -- Clan (running)
0x0000 0x0217: pmt_pid 0x07d0 RTVE -- RNE1 (running)
0x0000 0x0218: pmt_pid 0x07da RTVE -- RNEC (running)
0x0000 0x0219: pmt_pid 0x07e4 RTVE -- RNE3 (running)
Network Name 'RGE MADRID'
WARNING: filter timeout pid 0x0010
>>> tune to:
810000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
810000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
850000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
850000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
858000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
858000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
dumping lists (17 services)

Any ideas?

Regards,

tony

