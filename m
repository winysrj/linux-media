Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DLnoXq006466
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:49:50 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DLnJiM018667
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:49:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Robert William Fuller <hydrologiccycle@gmail.com>
Date: Mon, 13 Oct 2008 23:49:06 +0200
References: <48F3B56E.9050404@freemail.hu>
	<200810132328.47170.hverkuil@xs4all.nl>
	<48F3C060.2050302@gmail.com>
In-Reply-To: <48F3C060.2050302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200810132349.06834.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>,
	=?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH 2/2] video: simplify cx18_get_input() and	ivtv_get_input
	()
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

On Monday 13 October 2008 23:40:48 Robert William Fuller wrote:
> Hans Verkuil wrote:
> > On Monday 13 October 2008 22:54:06 Németh Márton wrote:
> >> From: Márton Németh <nm127@freemail.hu>
> >>
> >> The cx18_get_input() and ivtv_get_input() are called
> >> once from the VIDIOC_ENUMINPUT ioctl() and once from
> >> the *_log_status() functions. In the first case the
> >> struct v4l2_input is already filled with zeros,
> >> so doing this again is unnecessary.
> >
> > And in the second case no one cares whether the struct is zeroed.
> > And the same situation is also true for ivtv_get_output().
>
> Yeah, 'cos there's nothing better than uninitialized fields, like the
> recent report of a control that returns minimum and maximum values of
> zero, but a step-size of 9.  Why are we optimizing code paths that
> are not performance critical by uninitializing memory?

It's already initialized to 0 in v4l2-ioctl.c. No need to do it twice. 

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
