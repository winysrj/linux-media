Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o679otF9003214
	for <video4linux-list@redhat.com>; Wed, 7 Jul 2010 05:50:55 -0400
Received: from mail-bw0-f46.google.com (mail-bw0-f46.google.com
	[209.85.214.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o679ohwm012477
	for <video4linux-list@redhat.com>; Wed, 7 Jul 2010 05:50:44 -0400
Received: by bwz1 with SMTP id 1so5006702bwz.33
	for <video4linux-list@redhat.com>; Wed, 07 Jul 2010 02:50:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Jul 2010 11:50:42 +0200
Message-ID: <AANLkTikDO_YDvP6Bot0WW3259dYDvwnJsiLz83erXDji@mail.gmail.com>
Subject: saa7231 Help
From: Simon Appleby <v12diablo@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

First time posting on this list, I am hoping someone will be able to help.

I have a compro S800F Hybrid tuner card which which has a saa7231,
which I would like to get working for my MythTV box. I have found the
drivers at http://www.jusst.de/hg/saa7231/ but they are incomplete.
After a few hours of hacking around I have managed to get the card
recognised by the Kernel (2.6.32), and have succesfully gotten
/dev/video0 showing up, as well as the I2C communication returning
sensible looking data.
I was wondering if anyone has any info or data on this device they
could share? My queries to NXP, Trident and Manu Abraham have so far
gone unanswered. Im sort of fumbling around in the dark with a lot of
the chips hardware.

Regards

Simon Appleby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
