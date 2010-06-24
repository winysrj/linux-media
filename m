Return-path: <linux-media-owner@vger.kernel.org>
Received: from [200.29.137.120] ([200.29.137.120]:48816 "EHLO tesla.opendot.cl"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0FXUti (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 16:49:38 -0400
Message-ID: <4C23C7E3.40300@opendot.cl>
Date: Thu, 24 Jun 2010 17:02:27 -0400
From: "Reynaldo H. Verdejo Pinochet" <reynaldo@opendot.cl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Alan Carvalho de Assis <acassis@gmail.com>
Subject: Re: ISDB-T Tuning
References: <4C238B30.3050908@opendot.cl> <AANLkTilm8evyWV7hiP9f-Sb3DDKSGNpvqJXkZkm0hEuy@mail.gmail.com>
In-Reply-To: <AANLkTilm8evyWV7hiP9f-Sb3DDKSGNpvqJXkZkm0hEuy@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050600090708000708060407"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050600090708000708060407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Alan

Alan Carvalho de Assis wrote:
> If you have all frequencies supported in your country you can the
> "scan" command to detected all transmitted channels.

I do have them but scan is showing no results. I'm using a homemade
antenna that is giving 90-100% coverage with the windows app
so I'm rather sure this is not a signal strength nor snr issue.

Here is my freqs file

T 533143000 6MHz 3/4 3/4 AUTO 2k 1/32 NONE     # channel 24
T 533143000 6MHz 3/4 AUTO AUTO AUTO AUTO NONE   # channel 24
T 569143000 6MHz 3/4 3/4 AUTO 2k 1/32 NONE     # channel 30
T 569143000 6MHz 3/4 AUTO AUTO AUTO AUTO NONE   # channel 30
T 587143000 6MHz 3/4 3/4 AUTO 2k 1/32 NONE     # channel 33
T 587143000 6MHz 3/4 AUTO AUTO AUTO AUTO NONE   # channel 33
T 551143000 6MHz 3/4 3/4 AUTO 2k 1/32 NONE     # channel 27
T 551143000 6MHz 3/4 AUTO AUTO AUTO AUTO NONE   # channel 27

(entries repeated just to try out different combinations)

Now, I know for sure there is a 1seg broadcast at 587143 KHZ
, that's the one I'm getting with the windows app but scan on
Linux keeps showing no results.

I'm attaching the verbose scan output (I have also tried with
-5 with similar results):

Best regards

--
Reynaldo


--------------050600090708000708060407
Content-Type: text/plain;
 name="scan_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan_log"

scanning ChileISDBT
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 533143000 2 3 3 6 0 0 0
initial transponder 533143000 2 3 9 6 2 4 0
initial transponder 569143000 2 3 3 6 0 0 0
initial transponder 569143000 2 3 9 6 2 4 0
initial transponder 587143000 2 3 3 6 0 0 0
initial transponder 587143000 2 3 9 6 2 4 0
initial transponder 551143000 2 3 3 6 0 0 0
initial transponder 551143000 2 3 9 6 2 4 0
>>> tune to: 533143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 533143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 533143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 533143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 569143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 569143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 569143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 569143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 587143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 587143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 587143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 587143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 551143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 551143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_3_4:QAM_AUTO:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 551143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 551143000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_3_4:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

--------------050600090708000708060407--
