Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m82AnOwG002925
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 06:49:25 -0400
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m82An7oA013663
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 06:49:08 -0400
Message-ID: <13874.62.70.2.252.1220352545.squirrel@webmail.xs4all.nl>
Date: Tue, 2 Sep 2008 12:49:05 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Madhusudhan P" <madhusudhan.p@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: DirectFB supports V4L2 drives
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

> Hello,
>
>
>
> I am developing GUI on OSD DM6467 board. I am facing some issues regarding
> the DirectFB using V4L2 driver. I ported the DirectFB on DM6467 Davinci
> board and try to execute some test examples, where test program fails to
> recognize the video device.
>
>
>
> Does DirectFB have full support of V4L2 driver?

The DM644x has a framebuffer device, but not the DM6467. So DirectFB
doesn't work with the DM6467.

DirectFB is build on top of a linux framebuffer device and has no V4L2
support.

>
> Is it possible to access V4L2 driver to display UI menu using DirectFB?
>
>
>
> How to proceed with this? Please anyone working on this help me.

Sorry, I don't know enough about DirectFB to answer that.

Regards,

          Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
