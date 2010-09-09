Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o897c30u010983
	for <video4linux-list@redhat.com>; Thu, 9 Sep 2010 03:38:03 -0400
Received: from mtatransport.andago.com (mtatransport.andago.com
	[213.171.250.118])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o897bpS6008009
	for <video4linux-list@redhat.com>; Thu, 9 Sep 2010 03:37:53 -0400
Received: from localhost (antimalware.andago.com [192.168.17.224])
	by mtatransport.andago.com (Postfix) with ESMTP id BC879364BE
	for <video4linux-list@redhat.com>;
	Thu,  9 Sep 2010 09:37:49 +0200 (CEST)
Received: from mtatransport.andago.com ([192.168.17.223])
	by localhost (antimalware.andago.com [192.168.17.224]) (amavisd-new,
	port 10024)
	with ESMTP id uTo+HEz890P4 for <video4linux-list@redhat.com>;
	Thu,  9 Sep 2010 09:37:49 +0200 (CEST)
Received: from beleg.andago.net (beleg.andago.net [192.168.17.70])
	by mtatransport.andago.com (Postfix) with ESMTP
	for <video4linux-list@redhat.com>;
	Thu,  9 Sep 2010 09:37:49 +0200 (CEST)
Message-ID: <4C888ECC.3080104@andago.com>
Date: Thu, 09 Sep 2010 09:37:48 +0200
From: Jorge Cabrera <jorge.cabrera@andago.com>
MIME-Version: 1.0
To: Video 4 Linux Mailing List <video4linux-list@redhat.com>
Subject: Video capture device
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hello,

I wanted to set up a videoconference service at my company using a sony =

video camera with a usb video capture device and linux (Ubuntu to be =

specific). The videoconference system we're using is through webex and =

megameeting. I am currently using an Avermedia video capture device but =

the problem I had was that for this device the default input was "Tuner" =

and even dough I could set the default input to S-Video with v4l =

utilities this would only work with mplayer, vlc... but it wouldn't work =

with flash or java in a browser which are the technology behind most of =

online videoconference services. So after a month of banging my head =

against the wall I gave up and installed another operating system. =

Windows. Yes, I know.

But now I want to give it another try so this time I was thinking of =

trying with another video capture usb device so I wanted to ask the =

members of this list if you ever made one of this devices work perfectly =

under linux, specially with flash or java technologies. I think I would =

have the same problems with any Avermedia device so maybe there's =

something out there that works.

Thanks for your help,

Have a nice day

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
