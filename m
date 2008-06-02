Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m52JDqKv020994
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 15:13:52 -0400
Received: from mout4.freenet.de (mout4.freenet.de [195.4.92.94])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m52JCPOO024628
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 15:12:52 -0400
Received: from [195.4.92.16] (helo=6.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID fgunni@01019freenet.de) (port 25)
	(Exim 4.69 #19) id 1K3FS0-0005ji-Q7
	for video4linux-list@redhat.com; Mon, 02 Jun 2008 21:12:12 +0200
Received: from xdsl-84-44-197-99.netcologne.de ([84.44.197.99]:47939
	helo=[192.168.1.222])
	by 6.mx.freenet.de with esmtpsa (ID fgunni@01019freenet.de)
	(TLSv1:AES256-SHA:256) (port 25) (Exim 4.69 #12) id 1K3FS0-0003uU-Ik
	for video4linux-list@redhat.com; Mon, 02 Jun 2008 21:12:12 +0200
Message-ID: <4844460B.7030602@01019freenet.de>
Date: Mon, 02 Jun 2008 21:12:11 +0200
From: Frank Sagurna <fgunni@01019freenet.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Subject: HVR 1300 remote error, link to fix inside
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Seems this is not merged long time. I searched so long to find a
solution for my mail:
https://www.redhat.com/mailman/private/video4linux-list/2007-July/msg00040.html

Now i searched again, and found this solution:

http://www.linuxtv.org/pipermail/linux-dvb/2007-November/021867.html

I applied the changes, and remote gets recognized again.
Seems like a working patch and i would be happy if it gets included.

Regards

Frank
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIREYLrcfRHnkKaDYRAjY5AJ91fFbTbQLnkPVnHgW5JjgAheN99QCfUHZ0
30uY2onI5mVWkRTTbKtT3u0=
=0Ne0
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
