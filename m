Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78EoUMR020672
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:50:30 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78EmEdW015195
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:49:01 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808081635.20640.hverkuil@xs4all.nl>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
	<200808081635.20640.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 10:44:11 -0400
Message-Id: <1218206651.3003.54.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: CX18 Oops
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

On Fri, 2008-08-08 at 16:35 +0200, Hans Verkuil wrote:
> On Friday 08 August 2008 16:18:28 Andy Walls wrote:

> No objection at all. If you look at where cx18_queue_move is used, then 
> you'll notice that it is only in cx18_flush_queues(). And all it has to 
> do there is to move any buffers in the q_io or q_full queue to the 
> q_free queue and initialize all those buffers to their initial state. 
> You do not need all that complicated code for that. I suggest that you 
> make a new function instead that replaces cx18_queue_move and 
> cx18_queue_move_buf.

:)

I was especially annoyed at the local var that was named 'from_free' but
that was also used being for transfers *to* q_free, which happened to be
cx18's only use case for the variable.,,,

Regards,
Andy


> Regards,
> 
> 	Hans
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
