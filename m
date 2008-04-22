Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3M3RGiL008456
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 23:27:17 -0400
Received: from mta3.srv.hcvlny.cv.net (mta3.srv.hcvlny.cv.net [167.206.4.198])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3M3QsCb005445
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 23:26:55 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZP002DTIWPK850@mta3.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Mon, 21 Apr 2008 23:26:49 -0400 (EDT)
Date: Mon, 21 Apr 2008 23:26:49 -0400
From: Steven Toth <stoth@linuxtv.org>
To: linux-dvb <linux-dvb@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Message-id: <480D5AF9.4030808@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Cc: 
Subject: Hauppauge HVR1400 DVB-T support / XC3028L
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I've passed some patches to Mauro that add support for the Hauppauge 
HVR1400 Expresscard in DVB-T mode. (cx23885 bridge, dib7000p demodulator 
and the xceive xc3028L silicon tuner)

If you're interested in testing then wait for the patches to appear in 
the http://linuxtv.org/hg/v4l-dvb tree.

You'll need to download firmware from http://steventoth.net/linux/hvr1400

Post any questions or issues here.

Thanks,

Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
