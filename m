Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KEIar0019160
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:18:36 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KEIOaR017191
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:18:24 -0400
Message-ID: <48834928.6080207@linuxtv.org>
Date: Sun, 20 Jul 2008 10:18:16 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <200807181625.12619.hverkuil@xs4all.nl>
	<200807201447.35659.hverkuil@xs4all.nl>
In-Reply-To: <200807201447.35659.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: An example for RFC: Add support to query and change connections
 inside a media device
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

Hans Verkuil wrote:
> As usual, comments are welcome.

Why /dev/v4l/foo and not /dev/media/foo?

I think "v4l" is a poor choice -- v4l refers to video4linux, but Linux-DVB is it's own subsystem and its own branding.

If you want to be all-encompassing, then I think that "media" is a much better choice than "v4l".

-Mike


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
