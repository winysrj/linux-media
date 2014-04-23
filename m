Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35657 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbaDWClt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 22:41:49 -0400
Message-ID: <5357286A.7040005@iki.fi>
Date: Wed, 23 Apr 2014 05:41:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: dvbv5-zap LNA related bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

frontend c->frequency will not be set when LNA option is used.

[crope@localhost dvb]$ ./dvbv5-zap -c dvb_all_channel.conf MTV3 
--monitor --lna=1
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'dvb_all_channel.conf'
service has pid type 05:  6101
tuning to 714000000 Hz
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR: dvb_fe_set_parms failed (Invalid argument)
[crope@localhost dvb]$ ./dvbv5-zap -c dvb_all_channel.conf MTV3 
--monitor --lna=0
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'dvb_all_channel.conf'
service has pid type 05:  6101
tuning to 714000000 Hz
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR: dvb_fe_set_parms failed (Invalid argument)
[crope@localhost dvb]$ ./dvbv5-zap -c dvb_all_channel.conf MTV3 
--monitor --lna=-1
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'dvb_all_channel.conf'
service has pid type 05:  6101
tuning to 714000000 Hz
        (0x00)
Lock   (0x1f)
   dvb_set_pesfilter to 0x2000
^C[crope@localhost dvb]# now it workd
[crope@localhost dvb]$ # now it works
[crope@localhost dvb]$ ./dvbv5-zap -c dvb_all_channel.conf MTV3 
--monitor --lna=1
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'dvb_all_channel.conf'
service has pid type 05:  6101
tuning to 714000000 Hz
        (0x00)
Lock   (0x1f)
   dvb_set_pesfilter to 0x2000
^C[crope@localhost dvb]$

-- 
http://palosaari.fi/
