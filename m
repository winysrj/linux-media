Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIFIo31028222
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 10:18:50 -0500
Received: from tomts52-srv.bellnexxia.net (tomts52-srv.bellnexxia.net
	[209.226.175.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAIFIc5V008432
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 10:18:38 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: Thomas Reiter <x535.01@gmail.com>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Tue, 18 Nov 2008 10:17:56 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208165C79D3B1@Colmatec004.COLMATEC.INT>
References: <1226943947.6362.10.camel@ivan>
In-Reply-To: <1226943947.6362.10.camel@ivan>
Content-Language: fr-CA
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE : DVB-T2 (Mpeg4) in Norway
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

sorry I didn't specify the other way to get the firmware, depending if your device is using the em28xx driver

if you have the Windows drivers, u can extract from sys file

http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#Firmware_Information



example for a type vendor using empia chipset :

kworld : emBDA.sys

________________________________________
De : video4linux-list-bounces@redhat.com [video4linux-list-bounces@redhat.com] de la part de Thomas Reiter [x535.01@gmail.com]
Date d'envoi : 17 novembre 2008 12:45
À : video4linux-list@redhat.com
Objet : DVB-T2 (Mpeg4) in Norway

I bought a Pinnacle Nano USB stick and checked that this stick is OK
with the software from Pinnacle. Here in Norway DVB-T is coded with
Mpeg4, so it's a new experience.

With Ubuntu I tried something with "scan" and "Kaffeine" but both
programs were not able to detect some programs. It must be the old
firmware. Is someone able to help me to extract the firmware from my
snoopusb log?

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
