Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55867 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2CDV6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 16:58:50 -0500
Received: by iagz16 with SMTP id z16so4744672iag.19
        for <linux-media@vger.kernel.org>; Sun, 04 Mar 2012 13:58:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120304082531.1307a9ed@tele>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
 <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
 <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele>
From: Xavion <xavion.0@gmail.com>
Date: Mon, 5 Mar 2012 08:58:30 +1100
Message-ID: <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
To: Jean-Francois Moine <moinejf@free.fr>
Cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Francois

I can confirm that GSPCA v2.15.1 removes the bad pixels when I use
Cheese or VLC.  However, I'm sorry to report that the Motion problems
unfortunately still remain.  Is there something else I must do to
overcome the below errors?  I'm happy to keep testing newer GSPCA
versions for you until we get this fixed.


`--> tail /var/log/kernel.log
Mar  5 08:25:52 Desktop kernel: [ 6673.781987] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:52 Desktop kernel: [ 6673.813992] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6673.849986] gspca_main: frame
overflow 155693 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6673.881989] gspca_main: frame
overflow 156021 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6673.917991] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6673.949993] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6673.985990] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6674.021981] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6674.053985] gspca_main: frame
overflow 156309 > 155648
Mar  5 08:25:53 Desktop kernel: [ 6674.089989] gspca_main: frame
overflow 156309 > 155648


`--> tail /var/log/errors.log
Mar  5 08:24:16 Desktop motion: [1] v4l2_next: VIDIOC_QBUF: Invalid argument
Mar  5 08:24:16 Desktop motion: [1] Video device fatal error - Closing
video device
Mar  5 08:24:20 Desktop motion: [1] Retrying until successful
connection with camera
Mar  5 08:24:27 Desktop motion: [1] v4l2_next: VIDIOC_DQBUF: EIO
(s->pframe 3): Input/output error
Mar  5 08:24:27 Desktop motion: [1] v4l2_next: VIDIOC_QBUF: Invalid argument
Mar  5 08:24:27 Desktop motion: [1] Video device fatal error - Closing
video device
Mar  5 08:24:30 Desktop motion: [1] Retrying until successful
connection with camera
Mar  5 08:24:33 Desktop motion: [1] v4l2_next: VIDIOC_DQBUF: EIO
(s->pframe 0): Input/output error
Mar  5 08:24:33 Desktop motion: [1] v4l2_next: VIDIOC_QBUF: Invalid argument
Mar  5 08:24:33 Desktop motion: [1] Video device fatal error - Closing
video device
