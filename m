Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67NEEkg021111
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 19:14:14 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67NDW8D021621
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 19:13:56 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Brian Rogers <brian_rogers@comcast.net>
In-Reply-To: <48729CDD.9020404@comcast.net>
References: <1a1450dccf4940793d4e0635f4c9f2df.squirrel@www.lockie.ca>
	<48729CDD.9020404@comcast.net>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 01:10:13 +0200
Message-Id: <1215472213.3762.81.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: donate old hardware?
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

Hi James(!), Brian,

Am Montag, den 07.07.2008, 15:46 -0700 schrieb Brian Rogers:
> James wrote:
> > I have an MSI TV@nyhere Plus that I replaced.
> > The video works fine under Linux but the remote control doesn't (it works
> > under Windows).
> > I wonder if it is any use to a developer.
> > It is only an analog card and apparently it has ton of variations of the
> > remote and MSI is not Linux friendly.
> 
> I have one of these, too. There's actually a patch that was posted a
> while ago for IR support, which I've been using. It needs to be updated
> to apply to 2.6.26. After I do that, I plan to submit it here and get
> feedback for what changes are needed before submitting it upstream.
> Might as well announce that now...
> 

please submit.

It is a flaw in the driver not allowing to have it in yet.

Others are also depending on it to have it working out of tree again.

Thanks,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
