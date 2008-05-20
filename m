Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KKQxmt005529
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 16:26:59 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.186])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4KKQmaG026010
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 16:26:48 -0400
Received: by gv-out-0910.google.com with SMTP id n8so484406gve.13
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 13:26:38 -0700 (PDT)
Message-ID: <6cdc87030805201326k42740666h1266beb035aba684@mail.gmail.com>
Date: Tue, 20 May 2008 22:26:37 +0200
From: "Aimar Marco" <marco.aimar@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: saa7146 card
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

Hello,
I have a this card
#lspci -vv

02:0c.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Unknown device 4342:4343
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ed000000 (32-bit, non-prefetchable) [size=512]

02:0d.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Unknown device 4343:4343
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at ed001000 (32-bit, non-prefetchable) [size=512]

#xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.22.17-0.1-default)
xinerama 0: 1280x778+0+0
v4l2: open /dev/video0: No such file or directory
v4l2: open /dev/video0: No such file or directory
v4l: open /dev/video0: No such file or directory
no video grabber device available


and with this card I don't have a /dev/videoX.....
With another card (with chip bt878) my linux work (it created
/dev/video0)...any idea?
thank you



-- 
A presto, Aimar Marco
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
