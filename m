Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:47798 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZK2RPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 12:15:37 -0500
Date: Sun, 29 Nov 2009 18:15:43 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca sunplus: propagate error for higher level
Message-ID: <20091129181543.189dd34c@tele>
In-Reply-To: <4B1265E9.1040505@freemail.hu>
References: <4B093DDD.5@freemail.hu>
	<4B10CD81.7060909@freemail.hu>
	<20091128191717.5164a003@tele>
	<4B1265E9.1040505@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Nov 2009 13:15:37 +0100
Németh Márton <nm127@freemail.hu> wrote:

> I think that the return value of the usb_control_msg() is to be
> evaluated. If other drivers also not evaluating the usb_control_msg()
> *they* has to be fixed.
> 
> The benefit would be that the userspace program can recognise error
> condition faster and react accordingly. For example the USB device
> can be unplugged any time. In this case there is no use to continue
> sending URBs. Otherwise the user program thinks that everything went
> on correctly and the user will be surprised how come that he or she
> unplugged a device and it is still working.

I see 2 cases for getting errors in usb control messages:

- there are permanent problems in the USB subsystem
- device disconnection

The first case is detected immediately at probe time and the device
will not run (/dev/video<n> not created)

On device disconnection, if streaming is active, it is be stopped and
the device is marked for deletion. The only way to get errors in usb
control message is to change some control value at the same time the
device disconnects (i.e. disconnection while the ioctl runs in the
subdriver). The probability for this to occur is surely less than
10**-9. Otherwise, once the disconnection is seen, no IO may be
performed.

If you want absolutely to propagate the errors at higher level, the
simplest way is to have an 'error' variable in the gspca descriptor.
You set it to 0 in gspca.c before calling the subdriver (i.e. just after
getting the usb_lock), you check it before calling usb_control_msg (in
the low level routines reg_r, reg_w..) , you set it if this last
function returns an error, and you get its value before releasing the
usb_lock. In this way, there are less changes and less code overhead.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
