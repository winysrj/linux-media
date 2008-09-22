Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MHopmd008779
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 13:50:52 -0400
Received: from pne-smtpout1-sn2.hy.skanova.net
	(pne-smtpout1-sn2.hy.skanova.net [81.228.8.83])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MHodNC024500
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 13:50:40 -0400
Message-ID: <48D7DAE1.7040204@gmail.com>
Date: Mon, 22 Sep 2008 19:50:25 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: m560x driver devel <m560x-driver-devel@lists.sourceforge.net>,
	video4linux-list@redhat.com
Subject: [GSPCA] A couple of questions
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

Hi,
I've begun the working investigating the possibility of converting the
m5602 driver to the gspca framework.
I currently have the following questions:
1) From my understanding each driver implementing the gspca framework
has a static list of v4l2 controls. In the m5602 driver, each sensor has
its own set of v4l2 controls with different resolutions.
Is there a obious solution to this problem?

2) In the sd_desc struct, is it necessary to implement the dq_callback
or does the gspca driver automagically requeue buffers?

Thanks,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI19rhN7qBt+4UG0ERAl5wAJ9J/6kc6A2xYivmvl2hkT80ZVv0pgCfVSHR
oVCp/TzbqoqPOo7l6bS3Ifk=
=Ky0r
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
