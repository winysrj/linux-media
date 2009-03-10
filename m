Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx45.mail.ru ([94.100.176.59]:40960 "EHLO mx45.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZCJO6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 10:58:13 -0400
Received: from f139.mail.ru (f139.mail.ru [194.67.57.120])
	by mx45.mail.ru (mPOP.Fallback_MX) with ESMTP id 5E243E004399
	for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 17:37:08 +0300 (MSK)
Received: from mail by f139.mail.ru with local
	id 1Lh34N-0003Un-00
	for linux-media@vger.kernel.org; Tue, 10 Mar 2009 17:36:35 +0300
From: Goga777 <goga777@bk.ru>
To: linux-media@vger.kernel.org
Subject: =?koi8-r?Q?Re=3A_[linux-dvb]_Not_able_to_view_HD-TV_via_Technisat_Skystar_HD_2?=
Mime-Version: 1.0
Date: Tue, 10 Mar 2009 17:36:35 +0300
References: <49B67832.2060201@ewetel.net>
In-Reply-To: <49B67832.2060201@ewetel.net>
Reply-To: Goga777 <goga777@bk.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1Lh34N-0003Un-00.goga777-bk-ru@f139.mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 > since 3 days I have a Technisat Skystar HD 2 in my Computer (PCI-card) 
> 
> was my mail some days ago. My fault: I installed the multiproto-driver,
> cause I read this:
> 
> >  Mantis/S2API driver
> > 
> > This is the preferred driver. DVB-S2 support in the Linux kernel is provided by API version 5.0, also known as S2API (and not multiproto). This API was released in kernel version 2.6.28


please try http://mercurial.intuxication.org/hg/s2-liplianin s2api drivers 


> So I thought, I can only use this driver, if I use a kernel 2.6.28 which
> I do not and so I installed the multiproto-driver with part-success. But
> I read further and further and found out, that I was wrong. So yesterday
> I installed the S2API-driver with some more success. Channel-switching
> is very fast now and scan-s2 finds the hd-channels. I can even zap to a
> hd-channel, but viewing is the problem:
> 
> szap-output to a "normal" channel:
> 
> szap-s2 -a 0 -H -r -S 0 -n 373
> zapping to 373 'NDR FS NDS;ARD':
> delivery DVB-S, modulation QPSK
> sat 0, frequency 12109 MHz H, symbolrate 27500000, coderate 3/4, rolloff
> 0.35
> vpid 0x0a29, apid 0x0a2a, sid 0x0a2c
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal   0% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
> status 1f | signal   0% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
> (and so on)
> 
> mplayer-output for this channel:

please try to use another demuxer with mplayer from svn 

mplayer  -demuxer lavf 


> 
> VDecoder init failed :(
> Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family



