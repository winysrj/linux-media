Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UCDeYg027972
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 08:13:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8UCDRNQ031699
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 08:13:28 -0400
Date: Tue, 30 Sep 2008 14:12:59 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Vinicius Kamakura <thehexa@gmail.com>
Message-ID: <20080930121259.GA237@daniel.bse>
References: <20080908160012.574456184D5@hormel.redhat.com>
	<48C5948D.5030504@migmasys.com> <20080909190727.GA2184@daniel.bse>
	<3ebb0dc80809300125n24567d11kf4b414b7909c8270@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ebb0dc80809300125n24567d11kf4b414b7909c8270@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: a multichannel capture problem
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

On Tue, Sep 30, 2008 at 05:25:27AM -0300, Vinicius Kamakura wrote:
> On Tue, Sep 09, 2008 at 09:07:27PM +0200, Daniel Glöckner wrote:
> > Some time ago I made some experiments changing the input at random times
> > using direct hardware access while capturing. IIRC the chip will skip at
> > least one complete frame before it continues to capture.
> >
> 
> what do you mean by direct hardware access?

I mmap'ed /sys/class/video4linux/video0/device/resource0 and toggled
bit 5 of IFORM.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
