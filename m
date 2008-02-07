Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17E31T1022029
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 09:03:01 -0500
Received: from www.datavault.us (flatoutfitness.com [66.178.130.209])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17E2eVj008004
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 09:02:40 -0500
Received: from www.datavault.us ([192.168.128.6] ident=yan)
	by www.datavault.us with esmtps (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68) (envelope-from <yan@seiner.com>) id 1JN7Lc-0008Bf-Ii
	for video4linux-list@redhat.com; Thu, 07 Feb 2008 06:03:28 -0800
Message-ID: <47AB0FB0.5070503@seiner.com>
Date: Thu, 07 Feb 2008 06:03:28 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: hardware requirements for webcams?
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

Hi everyone:

I need to build an embedded platform that can handle 2 webcams, 
preferably at 640x480.  I've tested several typical embedded boards, 
with 200 MHz arm or mips CPUs, and they can handle 1 webcam at 480x320.

Googling on webcams indicates that each webcam would have to have its 
own USB controller as well as enough CPU horsepower to do the job (maybe 
something in the 800 MHz range?)

Is anyone aware of an inexpensive fanless board that could do this?  Or 
could provide some pointers on where I can look?

Thanks,

--Yan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
