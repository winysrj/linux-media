Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:55148 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1JMXvo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 19:51:44 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9DNpcED006148
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 19:51:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 3BCC91E0229
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 19:51:37 -0400 (EDT)
Message-ID: <4E977989.30808@lockie.ca>
Date: Thu, 13 Oct 2011 19:51:37 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: freeze/crash
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I have this: http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1250
I have kernel-3.0.4 and the daily media tree from 2011-10-13.

CIII-HD:85000000:8VSB:49:52:1
OTTAWA CBOFT-DT:189000000:8VSB:49:53:3
CJOH:213000000:8VSB:49:51:1
TVO    :533000000:8VSB:49:52:1
OTTAWA  CBOT-DT:539000000:8VSB:49:52:3
Télé-Québec_HD:569000000:8VSB:49:52:3
CHOT:629000000:8VSB:49:52:3

zap -channels channels.conf "CJOH'
Using frontend "Samsung 5H1409 QAM/8VSB Frontend", type ATSC
status | signal 000c | snr 000c | ber 00000000 | unc 00000000 |
crash

azap -c channels_X.conf "CJOH"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 213000000 Hz
video pid 0x0031 audio pid 0x0033
crash

It always crashes when I access the hardware but the place it crashes is 
random.

It could be the hardware but it is brand new.

