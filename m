Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H95FPl010929
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:05:15 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5H954eE027928
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:05:05 -0400
Received: by fg-out-1718.google.com with SMTP id e21so4032085fga.7
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 02:05:04 -0700 (PDT)
Message-ID: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
Date: Tue, 17 Jun 2008 14:35:04 +0530
From: "Veda N" <veda74@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: v4l2_pix_format doubts
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

I am trying to fill the structure v4l2_pix_format in the camera driver.

The v4l2_pix_format has the following variables to fill
  a) bytesperline
  b) width
  c) height
  4) pixelformat

 My datasheet says the size of each pixel is 12 bits per color channel.

 Hence for RGB will be 36bits.

 I wanted to know if the same hold true for YUV data.

In that case i was confused how to fill the bytesperline, width and
height field.

Can anyone help on this?

For 640x480 pixels what should be the value i should fill.

I am confused because for most drivers they take as 2 bytes per pixel.


Where are in my case i think it would be 36bits per pixel. am i wrong?



Regards,
vedan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
