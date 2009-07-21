Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:35913 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZGUPOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 11:14:53 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1213710qwh.37
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2009 08:14:52 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Antoine Jacquet <royale@zerezo.com>
Subject: Re: [PATCH] Implement changing resolution on the fly for zr364xx driver
Date: Tue, 21 Jul 2009 12:14:45 -0300
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
References: <200907152054.56581.lamarque@gmail.com> <200907202046.43194.lamarque@gmail.com> <4A65D0E2.4060108@zerezo.com>
In-Reply-To: <4A65D0E2.4060108@zerezo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907211214.46226.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Terça-feira 21 Julho 2009, Antoine Jacquet escreveu:
> Hi,

	Hi,

> > This patch implements changing resolution in zr364xx_vidioc_s_fmt_vid_cap
> > for zr364xx driver. This version is synced with v4l-dvb as of
> > 20/Jul/2009. Tested with Creative PC-CAM 880.
>
> Nice, I successfully tested your patch with 2 compatible webcams.
>  From the users feedbacks I had before, it seems that some devices do
> not support the 640x480 resolution, but I was not able to verify this
> myself.
> This is the only concern I have, since some users may think the driver
> is not working if the application automatically switches to the maximum
> resolution with an incompatible device.

	Maybe we should add a quirk list to prevent such cases or if send_control_msg 
returns error in such cases I can change the code to revert the change and 
keep the old resolution.

> > OBS: I had to increase MAX_FRAME_SIZE to prevent a hard crash in my
> > notebook (caps lock blinking) when testing with mplayer, which
> > automatically sets resolution to the maximum (640x480). Maybe we should
> > add code to auto-detect frame size to prevent this kind of crash in the
> > future.
>
> Yes, I also had this issue before. I don't know what is the good
> approach to determine the best size with JPEG compression.

	The driver reads data from USB port in 4096-bytes chunks, so before adding 
the data to frm->lpvbits we could verify if frm->lpvbits has enough space to 
hold it. If there is no enough space we can dynamically increase frm->lpvbits. 
In user space that can be done using realloc, I just do not know if there is a 
similar function in kernel space. OBS: frm->lpvbits had be increased without 
loosing the old data and of course we should have a upper limit, maybe 640 x 
480 * 3 (3 bytes per pixel) = 921600 bytes.

> I will push your changes to my tree and send a pull request to Mauro later.

	Ok, thanks.

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/
