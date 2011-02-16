Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx13.extmail.prod.ext.phx2.redhat.com
	[10.5.110.18])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1GMkj3C004658
	for <video4linux-list@redhat.com>; Wed, 16 Feb 2011 17:46:45 -0500
Received: from smtp2.sms.unimo.it (smtp2.sms.unimo.it [155.185.44.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GMkZ9q028464
	for <video4linux-list@redhat.com>; Wed, 16 Feb 2011 17:46:36 -0500
Received: from mail-qw0-f51.google.com ([209.85.216.51]:43859)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.69) (envelope-from <76466@studenti.unimore.it>)
	id 1Ppq8n-0004Ze-Ha
	for video4linux-list@redhat.com; Wed, 16 Feb 2011 23:46:33 +0100
Received: by qwb7 with SMTP id 7so1874863qwb.24
	for <video4linux-list@redhat.com>; Wed, 16 Feb 2011 14:46:32 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 16 Feb 2011 23:46:31 +0100
Message-ID: <AANLkTika03k=cppbejCHkuOT+Uq9ptVHZwYa80ubwLqT@mail.gmail.com>
Subject: Kernel configuration for ov9655 on the PXA27x Quick Capture Interface
From: Paolo Santinelli <paolo.santinelli@unimore.it>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi all,

I have an embedded smart camera equipped with an XScal-PXA270
processor running Linux 2.6.37 and the OV9655 Image sensor connected
on the PXA27x Quick Capture Interface.

Please, what kernel module I have to select in order to use the Image senso=
r ?

Thanks

Paolo Santinelli

-- =

--------------------------------------------------
Paolo Santinelli
ImageLab Computer Vision and Pattern Recognition Lab
Dipartimento di Ingegneria dell'Informazione
Universita' di Modena e Reggio Emilia
via Vignolese 905/B, 41125, Modena, Italy

Cell. +39 3472953357,=A0 Office +39 059 2056270, Fax +39 059 2056129
email:=A0 <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
URL:=A0 <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
--------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
