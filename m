Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QEeeks023095
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 10:40:40 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QEeRJ1014099
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 10:40:28 -0400
Date: Wed, 26 Mar 2008 15:40:20 +0100 (CET)
From: Balint Marton <cus@fazekas.hu>
To: =?UTF-8?B?UGV0ZXIgVsOhZ25lcg==?= <peter.v@datagate.sk>
In-Reply-To: <47E9F4F4.2050503@datagate.sk>
Message-ID: <Pine.LNX.4.64.0803261520340.14189@cinke.fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
	<47E9F4F4.2050503@datagate.sk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-943463948-1803057498-1206541579=:14189"
Content-ID: <Pine.LNX.4.64.0803261526341.14189@cinke.fazekas.hu>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-1803057498-1206541579=:14189
Content-Type: TEXT/PLAIN; CHARSET=ISO8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0803261526342.14189@cinke.fazekas.hu>

On Wed, 26 Mar 2008, Peter V=E1gner wrote:
> 1) are these patches already included in some repository? If not how shou=
ld I
> go about applying them? Is the diff command the right way? What branch ar=
e
> they against?
The patches are not inculded in any public repository. You can apply them=
=20
using the patch command. The patches are against the current v4l-dvb tree:=
=20
http://linuxtv.org/hg/v4l-dvb

> 2) The comments below indicates audio functionality for cx88 is not worki=
ng as
> it should. So shal I be able to get stereo sound after applying these pat=
ches?
Yes. Maybe the first tv channel after you start mplayer will be mono=20
(because of the buggy audio thread), but after you change the channel, auto=
=20
detection should work.

> 3) are there any tunner settings required in order to get stereo sound? o=
r
> perhaps settings for some other modules?
No.

> Thanks
You are welcome! Happy testing! :)

Regards,=20
  Marton
---943463948-1803057498-1206541579=:14189
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
---943463948-1803057498-1206541579=:14189--
