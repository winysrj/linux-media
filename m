Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA75iSS5030229
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 00:44:28 -0500
Received: from QMTA06.emeryville.ca.mail.comcast.net
	(qmta06.emeryville.ca.mail.comcast.net [76.96.30.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA75hTx5018490
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 00:43:30 -0500
Message-ID: <4913D57F.5010003@personnelware.com>
Date: Thu, 06 Nov 2008 23:43:27 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47C90994.8040304@personnelware.com>	<20080304113834.0140884d@gaivota>	<490E468A.6090200@personnelware.com>	<1225675203.3116.12.camel@palomino.walls.org>	<490E6EC3.7030408@personnelware.com>	<1225762470.3198.23.camel@palomino.walls.org>
	<4911414E.2050801@personnelware.com>
In-Reply-To: <4911414E.2050801@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthew Bettencourt <matt@mail.bettencourt.info>
Subject: Re: v4l2 api compliance test
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

I missed this: capture --read, a valid mode of vivi (at least it was not
reporting an error) is what is eating the memory.  guessing vivi, because I
don't think a user app can do what was happening.

A ubuntu dev has asked that I report it against the ubuntu kernel, so here it
is:  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/294951

Carl K








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
