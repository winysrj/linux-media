Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67MkhtU006613
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 18:46:43 -0400
Received: from QMTA05.emeryville.ca.mail.comcast.net
	(qmta05.emeryville.ca.mail.comcast.net [76.96.30.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67MkVMF007699
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 18:46:31 -0400
Message-ID: <48729CDD.9020404@comcast.net>
Date: Mon, 07 Jul 2008 15:46:53 -0700
From: Brian Rogers <brian_rogers@comcast.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <1a1450dccf4940793d4e0635f4c9f2df.squirrel@www.lockie.ca>
In-Reply-To: <1a1450dccf4940793d4e0635f4c9f2df.squirrel@www.lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

James wrote:
> I have an MSI TV@nyhere Plus that I replaced.
> The video works fine under Linux but the remote control doesn't (it works
> under Windows).
> I wonder if it is any use to a developer.
> It is only an analog card and apparently it has ton of variations of the
> remote and MSI is not Linux friendly.

I have one of these, too. There's actually a patch that was posted a
while ago for IR support, which I've been using. It needs to be updated
to apply to 2.6.26. After I do that, I plan to submit it here and get
feedback for what changes are needed before submitting it upstream.
Might as well announce that now...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
