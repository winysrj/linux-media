Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53LMaXW023710
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:22:36 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53LMMed006805
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:22:24 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K3dxP-0004dF-GR
	for video4linux-list@redhat.com; Tue, 03 Jun 2008 21:22:16 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 21:22:15 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 21:22:15 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Tue, 3 Jun 2008 21:22:06 +0000 (UTC)
Message-ID: <loom.20080603T211838-212@post.gmane.org>
References: <986038.14508.qm@web35602.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Re: Question - Component input via software card
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

Sam Logen <starz909 <at> yahoo.com> writes:

>  Would it be possible to connect component cables from
> a high def. video source to the video and audio
> composite plugs of the capture card, and have a
> program process the three streams together as video
> streams instead of video and audio streams, then save
> the result in a file?

That would not be possible with any off-the-shelf composite capture card, but it
would be possible to design your own capture hardware that could use the same
plugs for either audio or component video. Just getting a Hauppauge HD-PVR would
likely be cheaper.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
