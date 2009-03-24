Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2O9wENb021594
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 05:58:15 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2O9vtcs017838
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 05:57:55 -0400
Message-ID: <49C8AF04.7070208@hhs.nl>
Date: Tue, 24 Mar 2009 10:59:32 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
References: <200903231708.08860.lamarque@gmail.com>
In-Reply-To: <200903231708.08860.lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4l
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

On 03/23/2009 09:08 PM, Lamarque Vieira Souza wrote:
> 	Hi all,
>
> 	I am trying to make Skype work with my webcam (Creative PC-CAM 880, driver
> zr364xx). By what I have found Skype only supports YU12, YUYV and UYVY pixel
> formats, which libv4l supports as source formats only and not as destination
> formats.

YU12 is the same as YUV420 (planar) which skype does support. I assure you that
skype works with libv4l for cams which have a native format which skype does
not understand.

What is an other issue with skype is that it insists on asking 320x240, so if the
driver for your cam cannot deliver 320x240 and libv4l fails to make 320x240 out of
it in someway (see below) then skype will fail.

libv4l will crop 352x288 to 320x240 especially for skype, and it will downscale
640x480 to 320x240 for the same reason.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
