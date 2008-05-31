Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VKjuNK028395
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 16:45:56 -0400
Received: from smtp-vbr8.xs4all.nl (smtp-vbr8.xs4all.nl [194.109.24.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4VKjOQf015392
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 16:45:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Date: Sat, 31 May 2008 22:44:53 +0200
References: <200805311720.51821.tobias.lorenz@gmx.net>
In-Reply-To: <200805311720.51821.tobias.lorenz@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200805312244.54006.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 6/6] si470x: pri... vid.. controls
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

Hi Tobias,

On Saturday 31 May 2008 17:20, Tobias Lorenz wrote:
> Hi Mauro,
>
> I better resend this patch with a scrambled header...
> "private video controls" is regarded as suspicious header by the spam
> filter of video4linux-list.
>
> This patch brings the following changes:
> - private video controls
>   - to control seek behaviour
>   - to module parameters
>   - corrected access rights of module parameters
>   - separate header file to let the user space know about it

I noticed that the private controls do not use consecutive IDs. This 
means that an application can not enumerate them properly since the 
enumeration has to stop when EINVAL is returned by the VIDIOC_QUERYCTRL 
ioctl.

Use v4l2-ctl --list-ctrls to test whether all controls can be enumerated 
properly.

To be honest I've never been happy with the private controls. For the 
MPEG API I created the extended controls, which allowed me to group 
controls into classes (having a class for radio controls is perfectly 
feasible) and that included having private controls, but ensuring that 
all private controls have unique IDs and allowing for a more flexible 
enumeration. You might want to consider using this.

Also please ensure that there is decent documentation of the private 
controls, preferably in the v4l2 spec. The meaning of private controls 
tends to be lost in time if they are not carefully documented.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
