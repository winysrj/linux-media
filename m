Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37167 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZEBIyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 04:54:32 -0400
Received: by fxm2 with SMTP id 2so2665428fxm.37
        for <linux-media@vger.kernel.org>; Sat, 02 May 2009 01:54:31 -0700 (PDT)
Message-ID: <49FC0A45.2000705@gmail.com>
Date: Sat, 02 May 2009 10:54:29 +0200
From: Amir Bukhari <amir.bukhari@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB-C: bad receiving on kernel 2.6.28 (64 bit)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have before a running box with debain lenny and the kernel 2.6.24 (32 
bit).  I build the DVB from the old multiprotocol source (before more 
than one year). the system has work very well.

now I want to extend my system with new hardwares. the new hardwares are 
worked well on the old lenny system.
I install  xbuntu  (9.04) with the kernel 2.6.28 (64 bit).

my DVB-C cards are got detected (TT-C 1501 and DVB-C 2300 FF).
running scan detect all channels.

then running czap (for testing) I got:
############
czap -a 1 -c channels.zap -n 1 -H

using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
reading channels from file 'channels.zap'
  1 RTL 2:113000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_64:202:203:12020
  1 RTL 2: f 113000000, s 6900000, i 2, fec 0, qam 3, v 0xca, a 0xcb
status 1f | signal  75% | snr  13% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  75% | snr  13% | ber 31459 | unc 1383 | FE_HAS_LOCK
status 1f | signal  75% | snr  15% | ber 28906 | unc 1408 | FE_HAS_LOCK
status 1f | signal  75% | snr  14% | ber 29936 | unc 1230 | FE_HAS_LOCK
status 1f | signal  75% | snr  14% | ber 29022 | unc 851 | FE_HAS_LOCK
status 1f | signal  75% | snr  15% | ber 26547 | unc 616 | FE_HAS_LOCK
status 1f | signal  75% | snr  13% | ber 26656 | unc 780 | FE_HAS_LOCK
status 1f | signal  75% | snr  14% | ber 27935 | unc 655 | FE_HAS_LOCK
################

to be sure I compiled v4l-dvb from mercule (recent code from yesterday), 
but I got the same result.

is there any known problem with 64 bit (as my system has worked well on 
32 bit version)?

best regards,
-Amir
