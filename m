Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5N760Dd025878
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 03:06:00 -0400
Received: from mail8.sea5.speakeasy.net (mail8.sea5.speakeasy.net
	[69.17.117.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5N75mck015647
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 03:05:49 -0400
Date: Mon, 23 Jun 2008 00:05:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200806221334.45894.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0806230004370.29499@shell4.speakeasy.net>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
 attribute for persistent video4linux device nodes
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

On Sun, 22 Jun 2008, Hans Verkuil wrote:
> Isn't it better to have a static bitarray in videodev that keeps track
> of which devices are in use? Or if that's not possible for some reason,

Isn't there already an array that has a entry for each minor that's
in use?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
