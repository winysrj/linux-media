Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88De8QK003347
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 09:40:08 -0400
Received: from alquanto.nextra.it (alquanto.nextra.it [193.43.2.90])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n88Ddsil020675
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 09:39:56 -0400
Received: from becar.it (becaboj0.customer.nettuno.it [130.186.216.1])
	by alquanto.nextra.it (8.9.3/8.9.3/NETTuno 5.0) with ESMTP id PAA14277
	for <video4linux-list@redhat.com>;
	Tue, 8 Sep 2009 15:39:53 +0200 (MET DST)
Message-ID: <4AA65E79.4050500@becar.it>
Date: Tue, 08 Sep 2009 15:39:05 +0200
From: Fabrizio Bandiera <fabrizio.bandiera@becar.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: USB Camera and Linux for ARM
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

I'm using USB WebCam in Linux ARM-based evaulation board: i have 2 of 
them, AT91SAM9263EK (Atmel) and iMX27 (Freescale).

Thank to your patch now i don't have any oops when i start capturing 
images.

The problem is: the images i'm capturing from USB Camera are always 
broken as if some data packet coming from the camera is missed.

I'm using a cross compiled software to grab images using mapped buffer 
and read method but results are the same.

I tested 2 cameras: Philps SPC200 and Videology based on a em2820 chip. 
They work well in my Ubuntu PC

I tested kernel 2.6.27 for AT91SAM and 2.6.22 for iMX27

Any idea?

-- 
--------------------------------------------------

Ing. Fabrizio BANDIERA

Becar srl (gruppo BEGHELLI)
Viale della Pace 1
40050 Monteveglio (Bologna)

Tel.  051-6702242
Fax   051-6702186
Cell. 335-7000409


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
