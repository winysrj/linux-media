Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m486psHp010075
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 02:51:55 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net
	(elasmtp-mealy.atl.sa.earthlink.net [209.86.89.69])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m486pWul005098
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 02:51:32 -0400
Received: from [209.86.224.51] (helo=mswamui-thinleaf.atl.sa.earthlink.net)
	by elasmtp-mealy.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <aglover.v4l@mindspring.com>) id 1JtzyG-0001PC-HU
	for video4linux-list@redhat.com; Thu, 08 May 2008 02:51:16 -0400
Message-ID: <5143530.1210229476468.JavaMail.root@mswamui-thinleaf.atl.sa.earthlink.net>
Date: Wed, 7 May 2008 23:51:16 -0700 (GMT-07:00)
From: Adam Glover <aglover.v4l@mindspring.com>
To: video4linux-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: odd behavior in tuner module in hg and linux stable
Reply-To: Adam Glover <aglover.v4l@mindspring.com>
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

This has to do with the patch I submitted to add explicit
support for the ADS Tech Instant HDTV PCI card (PTV-380).

It appears that in the latest kernel stable release as well
as the hg snapshot I had used for the patch the tuner module
does not identify the tuner chip on its initial automatic
loadup.  I must rmmod and reinsert the tuner module before it
will report detecting the TDA9887 / TUV1236D tuner chips.

This did not happen with version 2.6.24.4 so I'm wondering
what changed?  As it stands, it's not fatal to have to remove
and reinsert the module but it's not right...

This seems to be change from the last couple of months that
has already made it into the stable kernel tree.

Incidentally, the dvb frontend loads and works despite the
tuner having not registered the chips.  I just have no control
over analog tuning.  I don't know if this is normal behavior
or not.

So is this some sort of bug or is there something I should
do with the card config when compiling the modules?

I'd like to see the card working (even though I have a pcHDTV
card coming in the mail...)

Adam Glover

(I do apologize if I did not submit that patch correctly...
I'm pretty sure I was wrong in not including relative paths
and that the patch had to be run inside the saa7134 folder...)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
