Return-path: <linux-media-owner@vger.kernel.org>
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:44119 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754280Ab2DTKhX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 06:37:23 -0400
Received: from iarmst.demon.co.uk ([62.49.16.35] helo=spike.localnet)
	by lon1-post-1.mail.demon.net with esmtp (Exim 4.69)
	id 1SLBDO-0006Q5-Y0
	for linux-media@vger.kernel.org; Fri, 20 Apr 2012 10:37:22 +0000
From: Ian Armstrong <mail01@iarmst.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: Tuning file for Crystal Palace, UK (post digital switch-over)
Date: Fri, 20 Apr 2012 11:37:21 +0100
References: <4F8EB71A.1010104@googlemail.com> <079b01cd1ecc$d3697d40$7a3c77c0$@co.uk>
In-Reply-To: <079b01cd1ecc$d3697d40$7a3c77c0$@co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204201137.21429.mail01@iarmst.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 April 2012, Ian Liverton wrote:

> Thanks for this - I was in the middle of trying to sort this out when it
> arrived!  When I use it with dvbscan, however, it seems to mis-detect the
> modulation on the SDN multiplex.  It's telling me it's QPSK rather than
> QAM_64.  Did you have any trouble with re-tuning?
> 
> >>> tune to:
> 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QPSK:TRANSMISSION_
> M ODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010

I had problems with MythTV (.23-fixes) which failed to detect any channels on 
this multiplex. Had to manually add it with the correct info before doing 
another scan. Using dvbsnoop to dump the NIT also shows QPSK instead of 
QAM_64.

   DVB-DescriptorTag: 90 (0x5a)  [= terrestrial_delivery_system_descriptor]
   descriptor_length: 11 (0x0b)
   Center frequency: 0x03041840 (= 506000.000 kHz)
   Bandwidth: 0 (0x00)  [= 8 MHz]
   priority: 1 (0x01)  [= HP (high priority) or Non-hierarch.]
   Time_Slicing_indicator: 1 (0x01)  [= Time Slicing is not used.)]
   MPE-FEC_indicator: 1 (0x01)  [= MPE-FEC is not used.)]
   reserved_1: 3 (0x03)
   Constellation: 0 (0x00)  [= QPSK]
   Hierarchy information: 0 (0x00)  [= non-hierarchical (native interleaver)]
   Code_rate_HP_stream: 2 (0x02)  [= 3/4]
   Code_rate_LP_stream: 0 (0x00)  [= 1/2]
   Guard_interval: 0 (0x00)  [= 1/32]
   Transmission_mode: 1 (0x01)  [= 8k mode]
   Other_frequency_flag: 1 (0x01)
   reserved_2: 4294967295 (0xffffffff)

-- 
Ian
