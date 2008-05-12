Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CBR1iX025106
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 07:27:01 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CBQnDn022982
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 07:26:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Mon, 12 May 2008 13:26:07 +0200
References: <e686f5060805070314r14f37642s2abf59322564d671@mail.gmail.com>
In-Reply-To: <e686f5060805070314r14f37642s2abf59322564d671@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121326.07568.hverkuil@xs4all.nl>
Cc: User discussion about IVTV <ivtv-users@ivtvdriver.org>
Subject: Re: Request for IVTV and CX18 stream.c driver changes
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

On Wednesday 07 May 2008 12:14:07 Brandon Jenkins wrote:
> Greetings,
>
> Please let me know if I should post this to another list. I run
> Ubuntu in 64-bit mode to make better use of the RAM stuffed into my
> server. The application I run for recording video is SageTV, and it
> is a 32-bit app.
>
> I have modified the source of ivtv-streams.c and cx18-streams.c to
> include .compat_ioctl = v4l_compat_ioctl32, in the
> cx18_v4l2_enc_fops, ivtv_v4l2_enc_fops and ivtv_v4l2_dec_fops
> initializations. Generally speaking the drivers are performing fine,
> but I have noticed a high amount of pixelization during motion
> scenes. I don't know if further abilities need to be added to make
> the driver work better or not.

Hi Brandon,

I've added the compat_ioctl to my tree and it should be moved upstream 
in the next few days.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
