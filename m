Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GHfLVb029257
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:41:21 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GHennp021497
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:40:49 -0400
From: Peter Missel <peter.missel@onlinehome.de>
To: video4linux-list@redhat.com
Date: Sun, 16 Mar 2008 18:40:37 +0100
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
In-Reply-To: <pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161840.37910.peter.missel@onlinehome.de>
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

Hi Daniel!

> The 0502 definition is incorrect for this card, due to its GPIO use. The
> Mini definition _is_ correct for it, in every way possible.

... except that the input list isn't. You got SVideo and Composite.

What exactly is the problem with GPIO use? Please give us your regspy results.

Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
