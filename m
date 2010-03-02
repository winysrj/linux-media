Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o229YnVe003583
	for <video4linux-list@redhat.com>; Tue, 2 Mar 2010 04:34:49 -0500
Received: from denebola.andago.com (denebola.andago.com [213.171.250.124])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o229YYpq029215
	for <video4linux-list@redhat.com>; Tue, 2 Mar 2010 04:34:35 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by denebola.andago.com (Postfix) with ESMTP id 903D211B927
	for <video4linux-list@redhat.com>; Tue,  2 Mar 2010 10:34:32 +0100 (CET)
Received: from denebola.andago.com ([127.0.0.1])
	by localhost (denebola.andago.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A4Q+bPqXIy6g for <video4linux-list@redhat.com>;
	Tue,  2 Mar 2010 10:34:31 +0100 (CET)
Received: from [192.168.16.16] (madrid.andago.com [213.171.250.126])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by denebola.andago.com (Postfix) with ESMTPS id 344C111B743
	for <video4linux-list@redhat.com>; Tue,  2 Mar 2010 10:34:31 +0100 (CET)
Message-ID: <4B8CDBAC.4030909@andago.com>
Date: Tue, 02 Mar 2010 10:34:36 +0100
From: Jorge Cabrera <jorge.cabrera@andago.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Ubuntu and AverMedia DVD EZMaker USB Gold
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi everyone,

I'm trying to make an "AverMedia DVD EZMaker USB Gold" work with Ubuntu =

(tried in a computer with 9.04 and other two with 9.10) with a Sony EVI =

D70P Camera. I installed the linux drivers from AverMedia and when I =

connect the device the system shows the following message when i run dmesg:

[69302.964025] usb 2-1: new high speed USB device using ehci_hcd and =

address 6
[69303.637332] usb 2-1: configuration #1 chosen from 1 choice
[69303.860132] C038 registered V4L2 device video0[video]
[69303.860160] C038 registered V4L2 device vbi0[vbi]
[69303.860440] C038 registered ALSA sound card 2

Problem is that when I connect the camera it doesn' work, tried with =

cheese, gstreamer-properties, camorama and always get the same error:

libv4l2: error getting pixformat: Invalid argument

I tried connecting the camera with s-video and composite video with the =

same result. Funny thing is that I get the same error without connecting =

the camera so I guess it's just a problem with the AverMedia device. =

Works well on Windows.

I've been reading a lot on this but still have no clues. Has anyone got =

this type of device working under linux? should I use some other driver?

I would really appreciate any help.

Cheers,

-- =

Jorge Cabrera
=C1ndago Ingenier=EDa - www.andago.com

Tel=E9fono: +34 916 011 373
M=F3vil: +34 637 741 034
e-mail: jorge.cabrera@andago.com

C/Alcalde =C1ngel Arroyo n.=BA10 1.=AAPl. (28904) Getafe, Madrid

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
