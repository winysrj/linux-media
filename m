Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DLf26S002139
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:41:02 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DLewQX014952
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:40:59 -0400
Received: by gxk8 with SMTP id 8so3461569gxk.3
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 14:40:58 -0700 (PDT)
Message-ID: <48F3C060.2050302@gmail.com>
Date: Mon, 13 Oct 2008 17:40:48 -0400
From: Robert William Fuller <hydrologiccycle@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <48F3B56E.9050404@freemail.hu>
	<200810132328.47170.hverkuil@xs4all.nl>
In-Reply-To: <200810132328.47170.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>,
	=?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Subject: Re: [PATCH 2/2] video: simplify cx18_get_input()
	and	ivtv_get_input()
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
> On Monday 13 October 2008 22:54:06 Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The cx18_get_input() and ivtv_get_input() are called
>> once from the VIDIOC_ENUMINPUT ioctl() and once from
>> the *_log_status() functions. In the first case the
>> struct v4l2_input is already filled with zeros,
>> so doing this again is unnecessary.
> 
> And in the second case no one cares whether the struct is zeroed. And 
> the same situation is also true for ivtv_get_output().

Yeah, 'cos there's nothing better than uninitialized fields, like the 
recent report of a control that returns minimum and maximum values of 
zero, but a step-size of 9.  Why are we optimizing code paths that are 
not performance critical by uninitializing memory?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
