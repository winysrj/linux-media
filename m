Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7G0iGWL001179
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 20:44:16 -0400
Received: from mail-yx0-f202.google.com (mail-yx0-f202.google.com
	[209.85.210.202])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7G0hwNO032492
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 20:43:58 -0400
Received: by yxe40 with SMTP id 40so3066140yxe.23
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 17:43:58 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Haavard Holm <haavard.holm@ntnu.no>
In-Reply-To: <4A872D3F.6020003@ntnu.no>
References: <4A872D3F.6020003@ntnu.no>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Aug 2009 03:43:52 +0300
Message-Id: <1250383433.28382.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Varying frame rate
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

On Sat, 2009-08-15 at 23:48 +0200, Haavard Holm wrote:
> Hello,
> 
>   I am writing an application that capture video/pictures from a webcam.
> My program is built on moinejf.free.fr/*svv*.*c*
> which again is built on v4l2spec.bytesex.org/v4l2spec/*capture*.*c*
> 
> OS is linux 2.6.29.6-217.2.3.fc11.x86_64
> Webcam is "Logitech Quickcam Pro for Notebooks" (046d:0991)
> 
> My obeservation is : Depending on what my camera focus on, the framerate
> varies from 5 to 15 fps. I have tried several times, same result.
> 
> Why is that. How can I avoid this ?
I have observed similar issues with uvc camera on my aspire one (low
frame rate while the illumination is low)

Probably this is a hardware issue, and maybe there is a control to turn
this off.

Best regards,
	Maxim Levitsky


> 
> Best regards
> 
> Håvard Holm
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
