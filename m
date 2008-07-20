Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KELfhE020312
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:21:41 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KELULp018499
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:21:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michael Krufky <mkrufky@linuxtv.org>
Date: Sun, 20 Jul 2008 16:21:23 +0200
References: <200807181625.12619.hverkuil@xs4all.nl>
	<200807201447.35659.hverkuil@xs4all.nl>
	<48834928.6080207@linuxtv.org>
In-Reply-To: <48834928.6080207@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807201621.23323.hverkuil@xs4all.nl>
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

On Sunday 20 July 2008 16:18:16 Michael Krufky wrote:
> Hans Verkuil wrote:
> > As usual, comments are welcome.
>
> Why /dev/v4l/foo and not /dev/media/foo?
>
> I think "v4l" is a poor choice -- v4l refers to video4linux, but
> Linux-DVB is it's own subsystem and its own branding.
>
> If you want to be all-encompassing, then I think that "media" is a
> much better choice than "v4l".
>
> -Mike


Fine by me! I did not dare to be so bold at this stage :-)

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
