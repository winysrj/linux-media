Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QHdnQR015349
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 13:39:49 -0400
Received: from scarface.websupport.sk (postfix@tonymontana.websupport.sk
	[81.89.48.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QHdPu8010935
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 13:39:25 -0400
From: Peter =?ISO-8859-1?Q?V=E1gner?= <peter.v@datagate.sk>
To: Balint Marton <cus@fazekas.hu>
In-Reply-To: <Pine.LNX.4.64.0803261520340.14189@cinke.fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
	<47E9F4F4.2050503@datagate.sk>
	<Pine.LNX.4.64.0803261520340.14189@cinke.fazekas.hu>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 18:39:14 +0100
Message-Id: <1206553154.7076.4.camel@vb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement stereo
	detection
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

Hello,
On St, 2008-03-26 at 15:40 +0100, Balint Marton wrote:
> Yes. Maybe the first tv channel after you start mplayer will be mono 
> (because of the buggy audio thread), but after you change the channel, auto 
> detection should work.
> 
Thanks a lot. I am very happy this works at least partially. I see there
will be problems while recording because when starting mencoder in the
scheduler I won't be able to switch channels to detect the stereo
reliably. I am just wondering might there be a way to fix also this
issue? Sometimes it works even at startup of the player but more
frequently it does not.

thanks once again

Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
