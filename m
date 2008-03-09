Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m29JKh78029656
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 15:20:43 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m29JJxHZ029961
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 15:20:00 -0400
Received: by nf-out-0910.google.com with SMTP id g13so606360nfb.21
	for <video4linux-list@redhat.com>; Sun, 09 Mar 2008 12:19:58 -0700 (PDT)
To: Trent Piepho <xyzzy@speakeasy.org>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <Pine.LNX.4.58.0803091131430.6667@shell2.speakeasy.net> (Trent
	Piepho's message of "Sun, 9 Mar 2008 11:32:16 -0700 (PDT)")
References: <patchbomb.1204999521@liva.fdsoft.se>
	<Pine.LNX.4.58.0803091131430.6667@shell2.speakeasy.net>
Date: Sun, 09 Mar 2008 20:19:54 +0100
Message-ID: <klk4rln6t.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features
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

> This really should be done with controls, not more module parameters.

I was not aware that you could add custom controls, your comment
prompted me to find V4L2_CID_PRIVATE_BASE in the V4L-spec. Expect a
revised patch using controls within a week or so...

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
