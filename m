Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HHhRKY024122
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 13:43:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HHhFcp031586
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 13:43:15 -0400
Date: Thu, 17 Jul 2008 13:43:12 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200807171940.38608.hverkuil@xs4all.nl>
Message-ID: <alpine.LFD.1.10.0807171342030.20641@bombadil.infradead.org>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200807171910.01863.hverkuil@xs4all.nl>
	<alpine.LFD.1.10.0807171320160.20641@bombadil.infradead.org>
	<200807171940.38608.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
 attribute for?persistent video4linux device nodes
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

On Thu, 17 Jul 2008, Hans Verkuil wrote:

> Mauro,
>
> I'll merge Brandon's patch and add a #define and comments afterwards.
> It's a bit overkill IMHO but discussing this takes longer than just
> putting in the code :-)

Seems fine to me.

As videodev is the core for V4L devices, it is never an overkill to make 
the code as readable as possible.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
