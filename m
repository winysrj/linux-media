Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NMRgPA016825
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:27:43 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NMRUjO002091
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:27:30 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Frederic CAND <frederic.cand@anevia.com>
In-Reply-To: <485FA5A8.9000103@anevia.com>
References: <485FA5A8.9000103@anevia.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 00:25:29 +0200
Message-Id: <1214259929.6208.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [HVR 1300] secam bg
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

Hi Frederic,

Am Montag, den 23.06.2008, 15:31 +0200 schrieb Frederic CAND:
> dear all
> I could not make secam b/g work on my hvr 1300
> ioctl returns -1, error "Invalid argument"
> I know my card is able to handle this tv norm since it's working fine
> (video and sound are ok) under windows
> anyone could confirm it isn't working ? any idea why, and how to make it 
> work ?

since without reply, I don't claim to have seriously looked at it, but
at least have one question myself.

In cx88-core is no define for SECAM B or G.

Do you use a signal generator?

Hartmut asked once on the saa7134 driver, if there are any known
remaining SECAM_BG users currently and we remained, that it is hard to
get really up to date global analog lists for current broadcasts and I
only could contribute that there was no single request for it during all
these last years.

You know countries still using it?

Thanks,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
