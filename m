Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:38666 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbZCQIfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 04:35:12 -0400
Date: Tue, 17 Mar 2009 09:28:54 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
Message-ID: <20090317092854.55f27763@free.fr>
In-Reply-To: <Pine.LNX.4.58.0903150805140.28292@shell2.speakeasy.net>
References: <20090314125923.4229cd93@free.fr>
	<20090314091747.21153855@pedra.chehab.org>
	<Pine.LNX.4.58.0903141315300.28292@shell2.speakeasy.net>
	<20090315105037.6266687a@free.fr>
	<Pine.LNX.4.58.0903150805140.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 08:14:56 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> > - this asks to have a kernel generated with CONFIG_NEW_LEDS,  
> 
> So?
>
> > - the user must use some new program to
> > access /sys/class/leds/<device>,  
> 
> echo, cat?
> 
> > - he must know how the LEDs of his webcam are named in the /sys
> > tree.  
> 
> Just give them a name like video0:power and it will be easy enough to
> associate them with the device.  I think links in sysfs would do it
> to, /sys/class/video4linux/video0/device/<ledname> or something like
> that.
> 
> The advantage of using the led class is that you get support for
> triggers and automatic blink functions, etc.

Sorry for I don't see the usage of blinking the LEDs for a webcam.

Again, using the led class makes me wonder about:

1) The end users.

Many Linux users don't know the kernel internal, nor which of the too
many applications they should use to make their devices work. If no
developper creates a tool to handle the webcams, the users have to
search again and again. Even if there is a full documentation, they
will try anything and eventually ask the kernel developpers why they
cannot have their LEDs switched on.

Actually, there are a few programs that can handle the webcam
parameters. In fact I know only 'v4l2-ctl': I did not succeeded to
compile qv4l2; v4l2ucp has been removed from Debian; and, anyway, these
programs don't handle the VIDIOC_G_JPEGCOMP and VIDIOC_S_JPEGCOMP
ioctls.

2) The memory overhead.

Using the led class adds more kernel code and asks the webcam drivers
to create a new device. Also, the function called for changing the LED
brighness cannot sleep, so the use a workqueue is required.

On contrary, with a webcam control, only one byte (for 8 LEDs) is added
to the webcam structure and the change is immediatly done in the ioctl.

3) The development time.

I already spent 2 hours to look how the led class was working. I am not
sure to develop a full LED mechanism in less than 5 to 8 hours, and, as
I cannot test it by myself, I will have to wait for testers to know if
the various protections (USB access, USB disconnection) work in all
cases.

Otherwise, adding a new control in a driver may be done in less than
half an hour, and, sure, it will work well at the first go!

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
