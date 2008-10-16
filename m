Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6x74X008565
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:59:07 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G6wvsS005057
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:58:57 -0400
Received: by wf-out-1314.google.com with SMTP id 25so3048737wfc.6
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 23:58:56 -0700 (PDT)
Message-ID: <aec7e5c30810152358t1f6f7187i844ac65980bf49a0@mail.gmail.com>
Date: Thu, 16 Oct 2008 15:58:56 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200810160855.35749.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<8763ntf3o8.fsf@free.fr>
	<aec7e5c30810152346q251c963h7a4419fa59fb6612@mail.gmail.com>
	<200810160855.35749.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Add ov772x driver
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

On Thu, Oct 16, 2008 at 3:55 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thursday 16 October 2008 08:46:31 Magnus Damm wrote:
>> I dislike the register access option since it requires the developer
>> to have some user space tool that most likely won't ship with the
>> kernel. I think seeing it as yet another video input source is pretty
>> clean. Or maybe it isn't very useful at all, I'm not sure. =)
>
> Just to give some background: register access can be done via the
> v4l2-dbg utility (see v4l2-apps/util) which uses the
> VIDIOC_DBG_G/S_REGISTER ioctls which are only compiled into the driver
> when the CONFIG_VIDEO_ADV_DEBUG option is set. This is the standard way
> of accessing registers.

Thanks for pointing that out!

> An alternative for selecting a test pattern could be to have two inputs:
> one is the camera and another one is the test pattern. Here too you
> could enable the test pattern input only if CONFIG_VIDEO_ADV_DEBUG is
> set.
>
> Just some ideas for you.

Yeah, maybe a combination of both register access and separate test
pattern input would be useful. I guess register access is a good first
step at least.

Thank you!

/ magnus

> Regards,
>
>        Hans
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
