Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server50105.uk2net.com ([83.170.97.106] helo=mail.autotrain.org)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tmw@autotrain.org>) id 1MLECL-0006fK-UF
	for linux-dvb@linuxtv.org; Mon, 29 Jun 2009 12:34:55 +0200
Received: from mail.autotrain.org (server50105.uk2net.com [127.0.0.1])
	by mail.autotrain.org (Postfix) with ESMTP id 6D8F7340DA
	for <linux-dvb@linuxtv.org>; Mon, 29 Jun 2009 11:34:50 +0100 (BST)
Received: from localhost (localhost [127.0.0.1])
	by mail.autotrain.org (Postfix) with ESMTP id 25FF8340DA
	for <linux-dvb@linuxtv.org>; Mon, 29 Jun 2009 11:34:50 +0100 (BST)
Date: Mon, 29 Jun 2009 11:34:50 +0100 (BST)
From: Tim Williams <tmw@autotrain.org>
To: linux-dvb@linuxtv.org
Message-ID: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>
MIME-Version: 1.0
Subject: [linux-dvb] USBVision device defaults
Reply-To: linux-media@vger.kernel.org
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


Hello,

I'm trying use a WinTV USB adaptor which uses the usbvision driver to 
capture the output of a video camera for streaming across the web, the 
idea being that there is a reliable local recording, even in the event of 
a computer crash, while allowing the remote viewers to see the proceedings 
live without needing to have two separate cameras.

Unfortunately there is a catch, i'm using flash to do the broadcast 
and flash (in common with a lot of other software of this type) doesn't 
have the ability to set the input type and picture format, so you are 
stuck with the default, which is the rf-tuner. I have managed to make my 
own bodged driver which disables the rf-input so that I can get a picture 
via s-video, but it is stubbornly stuck in black and white, which i'm 
assuming is some kind of colour format problem.

If I use KDETV to look at the picture then everything comes through in 
colour, so this would seem to be a problem with the defaults built into 
the module being incorrect for my circumstances. Rather than carrying on 
with my bodged driver (this is the first time I have ever attempted to 
modify a C programme), what would be really great is away to achieve one 
of the following :

1) Set the default input, tv standard and pixel format using module 
parameters in modprobe.conf
2) Get the driver to 'remember' it's current settings when switching 
between applications. The windows driver for these devices does this, so 
all I have to do under windows is start up WinTV, make sure I have a good 
picture, close it down again and then start up the video broadcast in 
flash.
3) A way to change the device settings using a 3rd party app even when the 
main video device is in use and can't be accessed. I've tried using v4lctl 
to set the parameters before starting a capture, but if the flash capture 
is active, then I (unsurprisingly) get device in use errors. If I use v4lctl 
before starting flash, then the settings don't stick. The capture box becomes 
active briefly (there is a red light on the box which indicates this), 
presumably accepts the setting and is then powered down again, causing 
the new setting to be immediately forgotten.

Any thoughts or help would be much appreciated.

Tim W

-- 
Tim Williams BSc MSc MBCS
Euromotor Autotrain LLP
58 Jacoby Place
Priory Road
Edgbaston
Birmingham
B5 7UW
United Kingdom

Web : http://www.autotrain.org
Tel : +44 (0)121 414 2214

EuroMotor-AutoTrain is a company registered in the UK, Registration
number: OC317070.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
