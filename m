Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sg1lp0088.outbound.protection.outlook.com ([207.46.51.88]:25929
	"EHLO APAC01-SG1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaFGA5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 20:57:04 -0400
From: James Harper <james@ejbdigital.com.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: fusion hdtv dual express 2
Date: Sat, 7 Jun 2014 00:41:17 +0000
Message-ID: <262b1efa828c406c82691ee6b5a34656@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After confirming that it was supported I just bought a fusion hdtv dual express PCI adapter, only to find that I'd bought the 'dual express 2' version, which isn't supported (not the first time I've made such a mistake).

This page http://www.linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express2 says that the new v2 card is still using CX23885 chipset but also uses DIB7070 (dib7000 + dib0070) which appears to be supported already but only via a few USB adapters.

With a bit of cut and paste I have added some support for the card, to the point that dvbtune now says:

# dvbtune -f 550500000 -bw 7 -c 2 -cr 3_4 -gi 16 -tm 8 -I 1 -m -i

Using DVB card "DiBcom 7000PC"
tuning DVB-T (in United Kingdom) to 550500000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
Bit error rate: 0
Signal strength: 49390
SNR: 233
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
<transponder type="T" freq="550500000">
Nothing to read from fd_pat
Nothing to read from fd_sdt
</transponder>
Signal=49402, Verror=0, SNR=228dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49397, Verror=0, SNR=226dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49377, Verror=0, SNR=235dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49336, Verror=0, SNR=230dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49345, Verror=0, SNR=235dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49374, Verror=0, SNR=232dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49352, Verror=0, SNR=254dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49396, Verror=0, SNR=241dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49344, Verror=0, SNR=243dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49353, Verror=0, SNR=258dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49309, Verror=0, SNR=248dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=49334, Verror=0, SNR=243dB, BlockErrors=0, (S|L|C|V|SY|)
^C

Which all looks correct at the start, but obviously not as it can't actually read the information in the dvb streams.

Is it likely that getting it working only requires a small amount of further tinkering, or am I likely wasting my time? I know next to nothing about dvb and how it all hangs together.

Thanks

James
