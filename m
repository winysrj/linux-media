Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7H8Dej3015682
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 04:13:40 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7H8Cx6O027212
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 04:13:15 -0400
Received: by ug-out-1314.google.com with SMTP id m2so75539uge.13
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 01:12:58 -0700 (PDT)
Message-ID: <226dee610808170112o5fa9dd6cue19ed080087d8a1@mail.gmail.com>
Date: Sun, 17 Aug 2008 13:42:58 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200808161528.46211.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808161528.46211.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, Michael Schimek <mschimek@gmx.at>
Subject: Re: V4L2 spec additions
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

I wasn't sure if anyone was updating the V4L2 specs documentation,
Is this an appropriate time to mention that the tables in the last pdf
version were broken ?

-JoJo

2008/8/16 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Michael,
>
> Attached is a patch that adds the documentation for some new MPEG stream
> types. These will appear in 2.6.28.
>
> It also adds the documentation for the V4L2_CID_CHROMA_AGC and
> V4L2_CID_COLOR_KILLER user controls that appeared in 2.6.26.
>
> Note that I did not update the videodev2.h that is Appendix A and I also
> did not update chapter 6.2 (the change history).
>
> Regards,
>
>        Hans
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
