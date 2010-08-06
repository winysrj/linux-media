Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o76FIDtJ024503
	for <video4linux-list@redhat.com>; Fri, 6 Aug 2010 11:18:13 -0400
Received: from smtp109.sbc.mail.gq1.yahoo.com (smtp109.sbc.mail.gq1.yahoo.com
	[67.195.14.39])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o76FHw5o013791
	for <video4linux-list@redhat.com>; Fri, 6 Aug 2010 11:17:58 -0400
Message-Id: <F3493459-FAEC-47CE-862A-E66123E83AE2@sbcglobal.net>
From: Dave Milici <davemilici@sbcglobal.net>
To: Vikram Ivatury <vikramivatury@gmail.com>
In-Reply-To: <AANLkTinGD4TB9MxbyYqYpfeDmsejhLSkzt0qB6CfQYWd@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: V4L2 Output Format
Date: Fri, 6 Aug 2010 08:17:56 -0700
References: <AANLkTinGD4TB9MxbyYqYpfeDmsejhLSkzt0qB6CfQYWd@mail.gmail.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


On Aug 5, 2010, at 3:46 PM, Vikram Ivatury wrote:

> I am using the .pixfmt = ATMEL_ISI_PIXFMT_CrYCbY and I am wondering  
> what my
> .capture_v4l2_fmt should be. Right now I have my .capture_v4l2_fmt =
> V4L2_PIX_FMT_VYUY but I think it should be V4L2_PIX_FMT_YUYV? Is  
> there a
> difference?

The difference is in the physical ordering of the Y vs U and V data as  
to which byte comes first (lowest in memory). Some graphics devices  
are able to offer the YUV packed formats with either ordering which is  
why this would be exposed. YUYV ordering is the most commonly used  
packed format.

> I am looking at Table 3-4 in the Atmel ISI datasheet and there is  
> nothing
> listed under the V4L format for my specific ISI input of CrYCbY. I  
> do not
> want a wrong .capture_v4l2_fmt to lead to a color corruption in the  
> preview
> path. I am using a YUV to RGB conversion in my capture.c program.

It will be obvious if you chose the wrong pixel format order. The  
colors will be all wrong and super-saturated intensity (like really  
bright orange).
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
