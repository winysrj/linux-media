Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.18]:10885 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751091Ab1HOXQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 19:16:37 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Josu Lazkano <josu.lazkano@gmail.com>
Subject: Re: Afatech AF9013
Date: Tue, 16 Aug 2011 01:16:15 +0200
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com> <201108160007.01022.jareguero@telefonica.net> <CAL9G6WWaUkD3AHhNKNOR65Mokm2qd9bwbKSpfYTzbOK-83zafA@mail.gmail.com>
In-Reply-To: <CAL9G6WWaUkD3AHhNKNOR65Mokm2qd9bwbKSpfYTzbOK-83zafA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108160116.15648.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Martes, 16 de Agosto de 2011 00:22:05 Josu Lazkano escribió:
> 2011/8/16 Jose Alberto Reguero <jareguero@telefonica.net>:
> > I have problems with a dual usb tuner. I limit the bandwith using pid
> > filters and the problem was gone.
> > 
> > Jose alberto
> > 
> > On Lunes, 15 de Agosto de 2011 15:34:20 Josu Lazkano escribió:
> >> Hello, I have a problem with the KWorld USB Dual DVB-T TV Stick (DVB-T
> >> 399U):
> >> http://www.linuxtv.org/wiki/index.php/KWorld_USB_Dual_DVB-T_TV_Stick_(DV
> >> B- T_399U)
> >> 
> >> I am using it on MythTV with Debian Squeeze (2.6.32). It is a dual
> >> device, sometimes the second adapter works great, but sometimes has a
> >> pixeled images. The first adapter always has pixeled images, I don't
> >> know how to describe the pixeled images, so here is a mobile record:
> >> http://dl.dropbox.com/u/1541853/kworld.3gp
> >> 
> >> I have this firmware:
> >> http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015
> >> .fw
> >> 
> >> I read on the linuxtv wiki and there are some problems with dual mode,
> >> there is some links for how to patch the similar driver (Afatech/ITE
> >> IT9135), but I am not good enough to understand the code.
> >> 
> >> I check the kernel messages:
> >> 
> >> Aug 15 13:53:58 htpc kernel: [ 516.285369] af9013: I2C read failed
> >> reg:d2e6 Aug 15 13:54:29 htpc kernel: [  547.407504] af9013: I2C read
> >> failed reg:d330 Aug 15 13:54:44 htpc kernel: [  561.902710] af9013: I2C
> >> read failed reg:d2e6
> >> 
> >> It looks I2C problem, but I don't know how to debug it deeper.
> >> 
> >> I don't know if this is important, but I compile the s2-liplianin for
> >> other devices this way:
> >> 
> >> apt-get install linux-headers-`uname -r` build-essential
> >> mkdir /usr/local/src/dvb
> >> cd /usr/local/src/dvb
> >> wget http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.zip
> >> unzip s2-liplianin-0b7d3cc65161.zip
> >> cd s2-liplianin-0b7d3cc65161
> >> make CONFIG_DVB_FIREDTV:=n
> >> make install
> >> 
> >> Can you help with this? This hardware is a very cheap and works well
> >> for HD channels but, I don't know why sometimes has pixeled images.
> >> 
> >> Thanks for your help, best regards.
> 
> Thanks Jose Alberto, I search on google for pid filters but I don't
> find any interesting info.
> 
> How can I limit bandwidth on dvb?
> 
> Thanks for your help, I have two dual devices waiting for this fix on my
> HTPC.
> 
> Best regards.

If  the driver has pid filters you can enable it with the parameter 
force_pid_filter_usage=1 of dvb-usb.

Jose Alberto
