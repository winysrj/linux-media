Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAHLSPoc005830
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 16:28:25 -0500
Received: from tomts47-srv.bellnexxia.net (tomts47-srv.bellnexxia.net
	[209.226.175.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAHLRUbB019646
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 16:27:30 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: Thomas Reiter <x535.01@gmail.com>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Mon, 17 Nov 2008 16:23:50 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208165C79D3AB@Colmatec004.COLMATEC.INT>
References: <1226943947.6362.10.camel@ivan>
	<09CD2F1A09A6ED498A24D850EB101208165C79D39F@Colmatec004.COLMATEC.INT>,
	<1226955828.6699.28.camel@ivan>
In-Reply-To: <1226955828.6699.28.camel@ivan>
Content-Language: fr-CA
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE : RE : DVB-T2 (Mpeg4) in Norway
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

Look at the usbvideo page,


in other words, record at least 200-300 meg

pres resume, pause to get the size

or by default in your windows repository the name of file inside usbsniff usbsnoop.log SIZE

Me, I unplug the signal during the log record, change video standard and resolution, dont know if this could help more but I could bet this could be usefull to detect exactly what you cahnge u will recognize as is inside the log !! ( some kind of message box for debugging info or log file... comments) u can find yourself
________________________________________
De : video4linux-list-bounces@redhat.com [video4linux-list-bounces@redhat.com] de la part de Thomas Reiter [x535.01@gmail.com]
Date d'envoi : 17 novembre 2008 16:03
À : video4linux-list@redhat.com
Objet : Re: RE : DVB-T2 (Mpeg4) in Norway

ma., 17.11.2008 kl. 13.23 -0500, skrev Jonathan Lafontaine:
> use usbreplay

Ok, I took now usbreplay and it seems that at the beginning of the log
(after rebooting) some 40 byte packages were send to the USB-device. How
could I get out the firmware?

Thanks

Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--

This message has been verified by LastSpam (http://www.lastspam.com) eMail security service, provided by SoluLAN
Ce courriel a ete verifie par le service de securite pour courriels LastSpam (http://www.lastspam.com), fourni par SoluLAN (http://www.solulan.com)
www.solulan.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
