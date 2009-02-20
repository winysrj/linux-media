Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1KFiegd002737
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:44:40 -0500
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1KFhPJU009782
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:43:25 -0500
Received: by gxk19 with SMTP id 19so2421968gxk.3
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 07:43:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8617.62.70.2.252.1235144231.squirrel@webmail.xs4all.nl>
References: <8617.62.70.2.252.1235144231.squirrel@webmail.xs4all.nl>
Date: Fri, 20 Feb 2009 10:43:25 -0500
Message-ID: <412bdbff0902200743h43b33222yd418a3e1083367ad@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: HVR-950q analog support - testers wanted
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

On Fri, Feb 20, 2009 at 10:37 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> A good test is to play with v4l2-ctl and check the implemented ioctls. I
> often discover that drivers forget to fill in some fields, or do not
> handle invalid input, etc. Esp. try v4l2-ctl --all and v4l2-ctl
> --list-ctrls-menus.

Thanks for the suggestion.

When I first started the work, I did play with the test tool that
enumerates through all the calls and dumps the output, although I
haven't tried that again in the last couple of days.

My bigger concern lies in identifying the little quirks in various
applications, like how tvtime does a set format with UYVY first, and
only if that call fails does it turn around and ask for YUYV (as
opposed to enumerating the available formats and picking one from the
list).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
