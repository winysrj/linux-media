Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m986A6sU002331
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 02:10:06 -0400
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m986A4Mu000712
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 02:10:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@nokia.com>
Date: Wed, 8 Oct 2008 08:09:53 +0200
References: <48E9F178.50507@nokia.com> <200810061838.38551.hverkuil@xs4all.nl>
	<48EB8BAC.90706@nokia.com>
In-Reply-To: <48EB8BAC.90706@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080809.53698.hverkuil@xs4all.nl>
Cc: vimarsh.zutshi@nokia.com, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: Re: [PATCH] V4L: Int if: Define new power state changes
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

On Tuesday 07 October 2008 18:17:48 Sakari Ailus wrote:
> ext Hans Verkuil wrote:
> > Hi Sakari,
> >
> > I'm OK with the other changes, but the V4L2_POWER_RESUME command in
> > this patch is still really very ugly. In my opinion you should
> > either let the slave store the old powerstate (this seems to be the
> > more logical approach), or let s_power pass the old powerstate as
> > an extra argument if you think it is really needed. But the RESUME
> > command is just unnecessary. Without the RESUME there is no more
> > need to document anything, since then it is suddenly
> > self-documenting.
>
> Yeah, I agree. I'll remove that and send a new patchset, this time
> with git-format-patch -n. :-)
>
> Ps. Last time the first patch got caught by a spam filter and my
> hunch is that it'll happen again.

No problems this time.

Anyway, here is my SoB for this series of 6 patches:

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Mauro, can you merge there patches directly, or do you want me to setup 
a v4l-dvb tree for you that you can merge from?

Thanks,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
