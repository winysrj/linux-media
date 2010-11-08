Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id oA8Hiers032306
	for <video4linux-list@redhat.com>; Mon, 8 Nov 2010 12:44:40 -0500
Received: from mail-ew0-f46.google.com (mail-ew0-f46.google.com
	[209.85.215.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oA8HiOXL002350
	for <video4linux-list@redhat.com>; Mon, 8 Nov 2010 12:44:25 -0500
Received: by ewy7 with SMTP id 7so3052428ewy.33
	for <video4linux-list@redhat.com>; Mon, 08 Nov 2010 09:44:24 -0800 (PST)
MIME-Version: 1.0
From: Vikram Ivatury <vikramivatury@gmail.com>
Date: Mon, 8 Nov 2010 12:44:03 -0500
Message-ID: <AANLkTikp9Ao9eVb61kL7aOUYiMzKBKO0+WxhN29E548J@mail.gmail.com>
Subject: Output Format Problems
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
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hello All,

I am trying to use the ISI "capture" example program and the CMOS camera
that I am using is capturing an image. However, anything red in the image
turns blue in the output. How can I go about changing this in the ISI
"capture" program? There is a YUV to RGB conversion that I believe is
causing the error with the Y, U or V values. Any suggestions?

Thanks,
Vikram
-- 
Vikram Ivatury
University of Michigan | Aerospace Engineering
Multi-Disciplinary Design | Space Systems Engineering
M-Cubed | Payload Team Lead
(301)-908-0448
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
