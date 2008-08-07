Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77HlTcx030085
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 13:47:30 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77HkTj9021713
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 13:46:38 -0400
Message-ID: <489B3725.7040105@hhs.nl>
Date: Thu, 07 Aug 2008 19:55:49 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Farkas Levente <lfarkas@lfarkas.org>
References: <489B342E.50506@lfarkas.org>
In-Reply-To: <489B342E.50506@lfarkas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: how to discover that a device is v4l or v4l2?
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

Farkas Levente wrote:
> hi,
> how can i discover whether a video device /dev/video0 is support v4l or 
> v4l2? currently if i try to use the wrong type in gstreamer it's hang 
> forever and only a hard kill can help.
> is there any way where can i find out the type?

Do an VIDIOC_QUERYCAP ioctl on it if it supports that its v4l2, if not it is v4l1

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
