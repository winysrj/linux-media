Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97EqdYM028435
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 10:52:39 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m97EqTiM023930
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 10:52:29 -0400
Date: Tue, 7 Oct 2008 16:52:06 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Brian Phelps <lm317t@gmail.com>
Message-ID: <20081007145206.GA1664@daniel.bse>
References: <ea3b75ed0810070657i2f673bb1ub858b2871d7b387a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea3b75ed0810070657i2f673bb1ub858b2871d7b387a@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: capture.c example (multiple inputs)
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

On Tue, Oct 07, 2008 at 09:57:28AM -0400, Brian Phelps wrote:
> I did some digging and it looks like this single chip bt878 card must
> cut the frame rate when switching inputs.  Is this correct?

correct.

> I found a 4-chip version from bluecherry.com that seems to do this at
> full 30 FPS per channel.

You mean .net, not .com?

Be warned, depending on your system there may be dropped pixels when
capturing four inputs at high resolution in inefficient color spaces.
Especially when you try to write the videos to harddisk while the
harddisk controller shares a PCI bus with the capture card.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
