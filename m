Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OJmuYS003938
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 15:48:56 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OJmi0q020114
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 15:48:44 -0400
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 427843F6251
	for <video4linux-list@redhat.com>;
	Tue, 24 Jun 2008 21:48:44 +0200 (CEST)
Received: from sidero.numenor.net (lac49-1-82-245-43-74.fbx.proxad.net
	[82.245.43.74])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 272013F6162
	for <video4linux-list@redhat.com>;
	Tue, 24 Jun 2008 21:48:44 +0200 (CEST)
From: stef <stef.dev@free.fr>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Tue, 24 Jun 2008 21:47:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242147.16503.stef.dev@free.fr>
Subject: PCTV 310c
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

	I'm still experimenting a few things with my pctv 310c. After trying to play 
with mts, the only I found to make it working reliably with SECAM-L is to 
build a custom firmware with added secam entries, the same than the existing 
ones, but with an mts type.
	The composite input works well, but I had to add 'audioroute=1' to have 
sound.
	
	Regarding the cx8802 device on it, is there any chance that mpeg encoding 
support will be added for this card ?

Regards,
	Stef

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
