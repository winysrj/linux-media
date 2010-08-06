Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o76MnXuH028021
	for <video4linux-list@redhat.com>; Fri, 6 Aug 2010 18:49:33 -0400
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.214.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o76MnLjO025189
	for <video4linux-list@redhat.com>; Fri, 6 Aug 2010 18:49:21 -0400
Received: by iwn33 with SMTP id 33so2107853iwn.33
	for <video4linux-list@redhat.com>; Fri, 06 Aug 2010 15:49:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F3493459-FAEC-47CE-862A-E66123E83AE2@sbcglobal.net>
References: <AANLkTinGD4TB9MxbyYqYpfeDmsejhLSkzt0qB6CfQYWd@mail.gmail.com>
	<F3493459-FAEC-47CE-862A-E66123E83AE2@sbcglobal.net>
From: Vikram Ivatury <vikramivatury@gmail.com>
Date: Fri, 6 Aug 2010 18:49:00 -0400
Message-ID: <AANLkTik1sHzJ74WHDck85QpLNOkniVargrn720+phYSX@mail.gmail.com>
Subject: Re: V4L2 Output Format
To: Dave Milici <davemilici@sbcglobal.net>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Dave,

Thanks for the quick reply. I will go ahead and use the YUYV packed format.
When I used the VYUY format, my output image was all green - any reasons you
think this might happen?

I am assuming that nothing is bring written to the image (all 0's in YUV
format) and then when it is converted to RGB that 0 is converted to a green
color value in RGB?

Thanks,
Vikram

On Fri, Aug 6, 2010 at 11:17 AM, Dave Milici <davemilici@sbcglobal.net>wrote:

>
> On Aug 5, 2010, at 3:46 PM, Vikram Ivatury wrote:
>
> I am using the .pixfmt = ATMEL_ISI_PIXFMT_CrYCbY and I am wondering what my
> .capture_v4l2_fmt should be. Right now I have my .capture_v4l2_fmt =
> V4L2_PIX_FMT_VYUY but I think it should be V4L2_PIX_FMT_YUYV? Is there a
> difference?
>
>
> The difference is in the physical ordering of the Y vs U and V data as to
> which byte comes first (lowest in memory). Some graphics devices are able to
> offer the YUV packed formats with either ordering which is why this would be
> exposed. YUYV ordering is the most commonly used packed format.
>
> I am looking at Table 3-4 in the Atmel ISI datasheet and there is nothing
> listed under the V4L format for my specific ISI input of CrYCbY. I do not
> want a wrong .capture_v4l2_fmt to lead to a color corruption in the preview
> path. I am using a YUV to RGB conversion in my capture.c program.
>
>
> It will be obvious if you chose the wrong pixel format order. The colors
> will be all wrong and super-saturated intensity (like really bright orange).
>



-- 
University of Michigan, Aerospace Engineering
Multi-Disciplinary Design - Space Systems Engineering
M-Cubed Payload Team Lead
Student Space Systems Fabrication Laboratory
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
