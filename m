Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C7mp8C032707
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 02:48:51 -0500
Received: from sandbox.cz (sandbox.cz [87.236.197.188])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1C7mS3g023810
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 02:48:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by sandbox.cz (Postfix) with ESMTP id C6A2D29F3A
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 08:48:21 +0100 (CET)
Received: from sandbox.cz ([127.0.0.1])
	by localhost (sandbox.cz [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Q9AX2ztEkxWx for <video4linux-list@redhat.com>;
	Tue, 12 Feb 2008 08:48:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by sandbox.cz (Postfix) with ESMTP id 756D173CB0
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 08:48:16 +0100 (CET)
Date: Tue, 12 Feb 2008 08:48:16 +0100 (CET)
From: Adam Pribyl <pribyl@lowlevel.cz>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802120826060.26704@sandbox.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: Lifeview NOT Hybrid PCI! LV3H
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

I got this new card from Lifeview. It is based on Conexant CX-23881, 
Xceive 3028 tuner and Intel CE6353 DVBT decoder.. When 
I used cx88xx driver it segfaults, upon suggestion by Mauro Carvalho 
Chehab in this bug http://bugzilla.kernel.org/show_bug.cgi?id=9876 I 
compiled cx88 with xc3028 support from mercurial.

Now it is better, driver identifies card as
cx88[0]: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT 
[card=63,autodetected]

and complains about
xc2028 1-0061: xc2028/3028 firmware name not set!
It is not loading xc firmware which I extracted into /lib/firmware 
according http://linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028

also it uses incorrect DVBT frontend
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...

The questions:
1. How is that possible that subsystem id 14f1:8852 is matching this card 
but it is already known for different card - can we have two cards with 
same ID?
2. why xc is not loading firmware, looking into source it should load 
xc3028-v27.fw, where I can set the firmware name (any modprobe option?)
3. is intel DVBT supported?

refs:
Similar card different vendor?
http://linuxtv.org/wiki/index.php/Leadtek_Winfast_PxDVR_3200_H
Pictures and other info about this Lifeview:
http://www.lowlevel.cz/log/pivot/entry.php?id=117

Thanks for any hint.

Adam Pribyl

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
