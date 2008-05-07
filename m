Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47AEIUZ001636
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 06:14:18 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47AE7PA003953
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 06:14:07 -0400
Received: by rv-out-0506.google.com with SMTP id f6so267416rvb.51
	for <video4linux-list@redhat.com>; Wed, 07 May 2008 03:14:07 -0700 (PDT)
Message-ID: <e686f5060805070314r14f37642s2abf59322564d671@mail.gmail.com>
Date: Wed, 7 May 2008 06:14:07 -0400
From: "Brandon Jenkins" <bcjenkins@gmail.com>
To: video4linux-list@redhat.com,
	"User discussion about IVTV" <ivtv-users@ivtvdriver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Request for IVTV and CX18 stream.c driver changes
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

Greetings,

Please let me know if I should post this to another list. I run Ubuntu
in 64-bit mode to make better use of the RAM stuffed into my server.
The application I run for recording video is SageTV, and it is a
32-bit app.

I have modified the source of ivtv-streams.c and cx18-streams.c to
include .compat_ioctl = v4l_compat_ioctl32, in the cx18_v4l2_enc_fops,
ivtv_v4l2_enc_fops and ivtv_v4l2_dec_fops initializations. Generally
speaking the drivers are performing fine, but I have noticed a high
amount of pixelization during motion scenes. I don't know if further
abilities need to be added to make the driver work better or not.

Thanks in advance,

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
