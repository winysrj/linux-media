Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JXmAC-0000c6-1v
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 00:39:48 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Raphael <rpooser@gmail.com>
In-Reply-To: <47D14F62.90406@gmail.com>
References: <47D14F62.90406@gmail.com>
Date: Sat, 08 Mar 2008 00:31:46 +0100
Message-Id: <1204932706.5376.5.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1250: v4l-dvb need help compiling
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Freitag, den 07.03.2008, 09:21 -0500 schrieb Raphael:
> Hello folks,
> I'm new to the list, and I subscribed mainly because I'm having a
> problem compiling the v4l-dvb drivers.
> I have a pinnacle PCTV HD Pro Stick and that is working fine using the 
> em28xx drivers from mcentral.de.
> Currently, I'm trying to get a Hauppage HVR-1250 working. At first when 
> I tried compiling v4l-dvb, I got errors about tea575x-tuner.c, and so 
> using make menuconfig, I disabled all AM/FM tuners.
> Howver, after that I still get an error during make, this time in
> videodev.c.
> The first error is "unknown field 'dev_attrs' specified in initializer"
> on line 491.
> 
> Has anyone seen this, or could I be doing something wrong when I removed
> the webcam drivers?
> 

this looks like you are using an older kernel for which we don't have
compatibility glue for sysfs currently.

Likely from 2.6.19 on, for sure with at least 2.6.20, you should be able
to overcome this.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
