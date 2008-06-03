Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53MSbnB028302
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 18:28:37 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53MSITT012788
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 18:28:20 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K3ezF-0007e0-Re
	for video4linux-list@redhat.com; Tue, 03 Jun 2008 22:28:13 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 22:28:13 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 22:28:13 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Tue, 3 Jun 2008 22:28:06 +0000 (UTC)
Message-ID: <loom.20080603T222332-642@post.gmane.org>
References: <c5bea28d26aa1caa1e85da.20080531171359.qnavryt4@webmail.dslextreme.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Changeset 7990 (was "Re: [PATCH] PowerColor RA330 (Real Angel 330)
	fixes")
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

Daniel Gimpelevich <daniel <at> gimpelevich.san-francisco.ca.us> writes:

> I finally got around to the RA330 patches. Here is hopefully the final
> fix. Also attached is the revised lircd.conf for its IR receiver. The IR
> codes are somehow different from what was needed with Markus Rechberger's
> flavor of the driver.
> 
> Next order of business: the KWorld ATSC120
> I see that initial support has already been added while I was dawdling.
> The I2C issues shouldn't be too big a hurdle...
>
> Attachment (patch1.diff): application/octet-stream, 1417 bytes
> Attachment (sam3507b.lircd.conf): application/octet-stream, 2160 bytes

Thanks for the commit, Mauro. Now I'm curious as to the wisdom of removing the
full retail name of the card from CARDLIST.cx88 in favor of its model number,
but I won't press the issue.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
