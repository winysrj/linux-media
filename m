Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0DEH3m5018145
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 09:17:07 -0500
Received: from smtp2.wa.amnet.net.au (smtp2.wa.amnet.net.au [203.161.124.51])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0DEGm0c023663
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 09:16:51 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp2.wa.amnet.net.au (Postfix) with ESMTP id 42D6DC3B52
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 22:16:56 +0800 (WST)
Received: from smtp2.wa.amnet.net.au ([127.0.0.1])
	by localhost (smtp2.wa.amnet.net.au [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id ajpfP3X5wT59 for <video4linux-list@redhat.com>;
	Wed, 13 Jan 2010 22:16:55 +0800 (WST)
Received: from mail.barber-family.id.au
	(202-89-184-139.static.dsl.amnet.net.au [202.89.184.139])
	by smtp2.wa.amnet.net.au (Postfix) with ESMTP id 51D5DC3B24
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 22:16:54 +0800 (WST)
Received: from [192.168.18.110] (unknown [192.168.18.110])
	by mail.barber-family.id.au (Postfix) with ESMTP id 4D489128050
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 22:16:44 +0800 (WST)
Message-ID: <4B4DD5CA.7020109@barber-family.id.au>
Date: Wed, 13 Jan 2010 22:16:42 +0800
From: Francis Barber <fedora@barber-family.id.au>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: unc problem on saa7134
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dear All,

I have a Compro Videomate DVBT 200A (I submitted a patch to support this 
card back in 2006 - thanks very much to Hartmut Hackmann for helping).  
It has worked fine for years, but recently my motherboard died and I 
replaced it with a board based on the NVIDIA nForce 610i chipset 
(http://www.asrock.com/mb/overview.asp?Model=n73v-s).  Now the card 
delivers poor picture quality. tzap shows the following output:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 191625000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal 9898 | snr 0000 | ber 0001fffe | unc ffffffff |
status 1f | signal 9898 | snr fefe | ber 000000e0 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000d8 | unc 0000001c | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000d6 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000c8 | unc 0000001b | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000e0 | unc 0000001c | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000e6 | unc 0000001b | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000d2 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000ce | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000c8 | unc 0000001b | 
FE_HAS_LOCK
status 1f | signal 9898 | snr fefe | ber 000000c8 | unc 00000053 | 
FE_HAS_LOCK

I can't remember exactly what values I used to get, except that unc used 
to be 0.

I'm using kernel 2.6.24-26 from Ubuntu 8.04.3 LTS.  Does anyone have 
ideas as to what my problem might be?  Things that have changed in the 
computer are RAM, CPU (was AMD Sempron 2800+, now Intel Celeron E3200), 
and motherboard as described above.

Thanks very much,
Frank.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
