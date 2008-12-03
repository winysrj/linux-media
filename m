Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3INxr0008260
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:23:59 -0500
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3INi1t023358
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:23:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ivtv-devel@ivtvdriver.org
Date: Wed, 3 Dec 2008 19:22:13 +0100
References: <de8cad4d0812022131h29832960y1881b79137b9fa46@mail.gmail.com>
In-Reply-To: <de8cad4d0812022131h29832960y1881b79137b9fa46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031922.13561.hverkuil@xs4all.nl>
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com,
	ivtv-users@ivtvdriver.org, Cody Pisto <cpisto@gmail.com>
Subject: Re: [ivtv-devel] Update request for attached patch:
	v4l2-compat-ioctl32.c
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

On Wednesday 03 December 2008 06:31:53 Brandon Jenkins wrote:
> Greetings all,
>
> Would anyone on the list be interested in updating the attached patch
> to work with the new structure of the v4l2-compat-ioctl32.c file? I
> use SageTV which is 32-bit on my 64-bit system and the newer driver
> base does not work with the attached patch. I attempted to contact
> the original dev of the patch and while someone volunteered to
> update, no update has been provided by the time discussed. As a
> result I am seeing messages like:
>
> compat_ioctl32: VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32: VIDIOC_S_EXT_CTRLS<6>cx18-1
> info: Start encoder stream encoder MPEG
>
> Thanks in advance,
>
> Brandon
>
> PS - I am not sure which list to post this on.

Hi Brandon,

Ah, yes, I received work-in-progress for this in the past from Cody, but 
never a final version.

Cody, do you have anything newer? And can you mail a Signed-off-by line 
for me? I can work on it a bit more to make it more complete.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
