Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UCjpQI009336
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 08:45:51 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8UCjjLu018713
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 08:45:45 -0400
Date: Tue, 30 Sep 2008 14:45:28 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Elvis Chen <chene77@hotmail.com>
Message-ID: <20080930124528.GA442@daniel.bse>
References: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
	<20080301234821.GA1691@daniel.bse>
	<BAY122-W277E26F7DB592126DD2175AA400@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY122-W277E26F7DB592126DD2175AA400@phx.gbl>
Cc: video4linux-list@redhat.com
Subject: Re: newbie programming help:  grabbing image(s) from /dev/video0,
	example code?
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

On Mon, Sep 29, 2008 at 08:58:05PM +0000, Elvis Chen wrote:
> and it appears that the Hauppauge pvr-150 does not:

You are right, ivtv supports only read/write access.

> is there another way to increase the performance?

Have you tried reading in a thread separate from the image processing
(with multiple frame buffers)?

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
