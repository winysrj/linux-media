Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59983 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbaIWKyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 06:54:20 -0400
Message-ID: <54215158.6000607@iki.fi>
Date: Tue, 23 Sep 2014 13:54:16 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow Chen <Bimow.Chen@ite.com.tw>, linux-media@vger.kernel.org
Subject: Re: [1/2] af9033: fix it9135 strength value not correct issue
References: <1411465442.1919.6.camel@ite-desktop>
In-Reply-To: <1411465442.1919.6.camel@ite-desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Bimow!
Thank you for improving these statistics.

I did a quite much changes, basically re-implemented all the 
af9033/it9133 demod statistics, already. I am not sure if you saw those, 
but please look that tree first:
http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=devel-3.17-rc6

If you want to some more statistics changes, please to top of that tree. 
We currently have 2 APIs for statistics. Old DVBv3 which uses frontend 
callbacks: read_snr, read_signal_strength, read_ber and read_ucblocks. 
New DVBv5 API uses different commands, which reads values from frontend 
cache.

Driver implements now DVBv5 statistics. Old DVBv3 statistics are there 
still, but those are just wrappers to return DVBv5 statistics.

You would like to examine these patches first:

$ git log media/devel-3.17-rc6 --oneline|grep af9033
2db4d17 [media] af9033: init DVBv5 statistics
ef2fb46 [media] af9033: remove all DVBv3 stat calculation logic
e53c474 [media] af9033: wrap DVBv3 BER to DVBv5 BER
1d0ceae [media] af9033: wrap DVBv3 UCB to DVBv5 UCB stats
6bb096c [media] af9033: implement DVBv5 post-Viterbi BER
204f431 [media] af9033: implement DVBv5 stat block counters
6b45778 [media] af9033: wrap DVBv3 read SNR to DVBv5 CNR
3e41313 [media] af9033: implement DVBv5 statistics for CNR
83f1161 [media] af9033: implement DVBv5 statistics for signal strength


I am happy to took improvements which are done top of these.

regards
Antti

-- 
http://palosaari.fi/
