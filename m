Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o75MlBRJ001701
	for <video4linux-list@redhat.com>; Thu, 5 Aug 2010 18:47:12 -0400
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.214.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o75MkxMm019643
	for <video4linux-list@redhat.com>; Thu, 5 Aug 2010 18:46:59 -0400
Received: by iwn33 with SMTP id 33so731737iwn.33
	for <video4linux-list@redhat.com>; Thu, 05 Aug 2010 15:46:59 -0700 (PDT)
MIME-Version: 1.0
From: Vikram Ivatury <vikramivatury@gmail.com>
Date: Thu, 5 Aug 2010 18:46:38 -0400
Message-ID: <AANLkTinGD4TB9MxbyYqYpfeDmsejhLSkzt0qB6CfQYWd@mail.gmail.com>
Subject: V4L2 Output Format
To: video4linux-list@redhat.com
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

Hello,

I am currently trying to fill out my platform data structure in the ISI
section of my driver code and I had a question.

I am using the .pixfmt = ATMEL_ISI_PIXFMT_CrYCbY and I am wondering what my
.capture_v4l2_fmt should be. Right now I have my .capture_v4l2_fmt =
V4L2_PIX_FMT_VYUY but I think it should be V4L2_PIX_FMT_YUYV? Is there a
difference?

I am looking at Table 3-4 in the Atmel ISI datasheet and there is nothing
listed under the V4L format for my specific ISI input of CrYCbY. I do not
want a wrong .capture_v4l2_fmt to lead to a color corruption in the preview
path. I am using a YUV to RGB conversion in my capture.c program.

Thanks,
Vikram

-- 
University of Michigan, Aerospace Engineering
Multi-Disciplinary Design - Space Systems Engineering
M-Cubed Payload Team Lead
Student Space Systems Fabrication Laboratory
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
