Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBNImu9a008028
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 13:48:56 -0500
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBNIme9I006330
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 13:48:41 -0500
From: heiko <hr17@online.de>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Tue, 23 Dec 2008 19:48:38 +0100
Message-Id: <1230058118.11067.4.camel@heiko-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: High bit error rate with Hauptaug Nova-SE2 and new PC
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

after a bigger change in hardware and software I have trouble to get my
Nova-SE2 reasonable working. I have hat the Nova-SE2 already running
fine in an older PC (Athlon XP 3000+) with linux vdr. 

My new PC has the following main components:
ASUS P5N-E SLI
Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz
Hauppauge Nova-SE2 DVB
ZOTAC GeForce 9600 GT

Ubuntu 8.10 
kernel: 2.6.27-9-generic
newest LinuxTV dbb driver

TV viewing (dvb-s) with all programs (mplayer, kaffeine) shows a lot of
failures. 
The bit error rate shown by femon or szap is quit high. 
Remarkable is that the bit error rate is mostly at zero in text mode. 
I would have suspected that there is an interference between the
Nova-SE2 and the graphic card. But there is now problem with the same PC
with windows software. 

The cx88 driver has its own irq. 
cat /proc/interrupts
...
17: 1350104 0 IO-APIC-fasteoi cx88[0], cx88[0]

I don't have any idea anymore. Therefore I could need some helpful hints
for further investigation. 
I hope I have use the right forum for this question (asking for help) .
If not please apologize me. 

Thanks
heiko

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
