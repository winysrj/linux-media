Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9CcpxN002596
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 07:38:51 -0500
Received: from mail1.mxsweep.com (mail150.ix.emailantidote.com
	[89.167.219.150])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9CbZNT024796
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 07:37:36 -0500
Message-ID: <493E665B.5040509@draigBrady.com>
Date: Tue, 9 Dec 2008 12:36:43 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
To: Brian Rosenberger <brian@brutex.de>
References: <1228493415.439.8.camel@bru02>	<412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>	<1228499124.2547.6.camel@bru02>	<412bdbff0812050949s545547d2v92bd3633b76b478e@mail.gmail.com>
	<1228583227.6281.1.camel@bru02>
In-Reply-To: <1228583227.6281.1.camel@bru02>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
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

Brian Rosenberger wrote:
> Am Freitag, den 05.12.2008, 12:49 -0500 schrieb Devin Heitmueller:
> 
>> Yes, that's exactly what I needed to know.  If you can get the Windows
>> USB trace, we should be able to extract the GPIOs from that and add
>> the device support.

Isn't that card already supported here?
http://mcentral.de/hg/~mrec/em28xx-new/file/3fe18e8981e5/em28xx-cards.c

I'm worried that there is more duplication of work now happening,
and things are going to get even more out of sync.

Devin, perhaps you could help with merging Markus' driver into mainline?

cheers,
Pádraig.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
