Return-path: <linux-media-owner@vger.kernel.org>
Received: from sclnz.com ([203.167.202.17]:34114 "EHLO smtp.sclnz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760423AbZEHALZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 20:11:25 -0400
Received: from gecko (localhost.localdomain [127.0.0.1])
	by smtp.sclnz.com (8.13.8/8.13.8/Debian-3) with ESMTP id n480so0q024463
	for <linux-media@vger.kernel.org>; Fri, 8 May 2009 12:54:51 +1200
Message-ID: <4A037932.5060901@sclnz.com>
Date: Fri, 08 May 2009 12:13:38 +1200
From: Rex J <biteme@sclnz.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: CX24123 no FE_HAS_LOCK/tuning failed.
References: <4A02C426.2030703@wowway.com> <1241701946.6790.38.camel@john-desktop>
In-Reply-To: <1241701946.6790.38.camel@john-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

John Donoghue wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9476 where I outlined a
>   

More, i created a channels.conf file, tried using szap, to no avail.

root@mythbox:~# szap "TV ONE"
reading channels from file '/home/rex/.szap/channels.conf'
zapping to 2 'TV ONE':
sat 0, frequency = 12483 MHz H, symbolrate 22500000, vpid = 0x0203, apid 
= 0x028d
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
May  8 12:07:20 mythbox kernel: [  953.539426] cx88[0]/2-dvb: 
cx8802_dvb_advise_acquire
May  8 12:07:20 mythbox kernel: [  953.539497] CX24123: cx24123_initfe: 
init frontend
May  8 12:07:20 mythbox kernel: [  953.559600] 
isl6421_set_tone(SEC_TONE_OFF)<7>CX24123: cx24123_send_diseqc_msg:
May  8 12:07:20 mythbox kernel: [  953.723705] CX24123: 
cx24123_diseqc_send_burst:
status 01 | signal 0700 | snr a423 | ber 00000000 | unc fffffffe |
May  8 12:07:20 mythbox kernel: [  953.840857] 
isl6421_set_tone(SEC_TONE_ON)<7>CX24123: cx24123_set_frontend:
May  8 12:07:20 mythbox kernel: [  953.842555] CX24123: 
cx24123_set_inversion: inversion auto
May  8 12:07:20 mythbox kernel: [  953.844856] CX24123: cx24123_set_fec: 
set FEC to auto
May  8 12:07:20 mythbox kernel: [  953.848464] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  8 12:07:20 mythbox kernel: [  953.848469] CX24123: 
cx24123_pll_tune: frequency=1883000
May  8 12:07:20 mythbox kernel: [  953.848471] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  8 12:07:20 mythbox kernel: [  953.854740] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  8 12:07:20 mythbox kernel: [  953.860992] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  8 12:07:20 mythbox kernel: [  953.867270] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4746
May  8 12:07:20 mythbox kernel: [  953.875157] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049862
May  8 12:07:20 mythbox kernel: [  953.880585] CX24123: 
cx24123_read_signal_strength: Signal strength = 1792
May  8 12:07:20 mythbox kernel: [  953.881930] CX24123: 
cx24123_read_snr: read S/N index = 42019
May  8 12:07:20 mythbox kernel: [  953.883928] CX24123: 
cx24123_read_ber: BER = 0
status 01 | signal 0600 | snr a327 | ber 00000000 | unc fffffffe |
May  8 12:07:21 mythbox kernel: [  954.885962] CX24123: 
cx24123_read_signal_strength: Signal strength = 1536
May  8 12:07:21 mythbox kernel: [  954.887293] CX24123: 
cx24123_read_snr: read S/N index = 41767
May  8 12:07:21 mythbox kernel: [  954.889290] CX24123: 
cx24123_read_ber: BER = 0
status 01 | signal 0600 | snr a2b0 | ber 00000000 | unc fffffffe |
May  8 12:07:22 mythbox kernel: [  955.891312] CX24123: 
cx24123_read_signal_strength: Signal strength = 1536
May  8 12:07:22 mythbox kernel: [  955.892636] CX24123: 
cx24123_read_snr: read S/N index = 41648
May  8 12:07:22 mythbox kernel: [  955.894627] CX24123: 
cx24123_read_ber: BER = 0
status 01 | signal 0600 | snr a33a | ber 00000000 | unc fffffffe |
May  8 12:07:23 mythbox kernel: [  956.896657] CX24123: 
cx24123_read_signal_strength: Signal strength = 1536
May  8 12:07:23 mythbox kernel: [  956.897991] CX24123: 
cx24123_read_snr: read S/N index = 41786
May  8 12:07:23 mythbox kernel: [  956.899987] CX24123: 
cx24123_read_ber: BER = 0
status 01 | signal 0600 | snr a3d4 | ber 00000000 | unc fffffffe |

*What is this telling me?*

Cheers, Rex
