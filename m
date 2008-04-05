Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rvm3000@gmail.com>) id 1JiIDc-0005Yc-VB
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 01:54:49 +0200
Received: by an-out-0708.google.com with SMTP id d18so182660and.125
	for <linux-dvb@linuxtv.org>; Sat, 05 Apr 2008 16:54:33 -0700 (PDT)
Message-ID: <f474f5b70804051654h3ee0bdd5u6eb19db2ac626845@mail.gmail.com>
Date: Sun, 6 Apr 2008 01:54:33 +0200
From: rvm <rvm3000@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <47F44538.2090508@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <f474f5b70804021720i7926ea17q77b3ef551fb0841f@mail.gmail.com>
	<47F44538.2090508@iki.fi>
Subject: Re: [linux-dvb] Pinnacle PCTV 71e
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

2008/4/3, Antti Palosaari <crope@iki.fi>:
> rvm wrote:
>
> > Isn't still possible to use the Pinnacle PCTV 71e in linux?
> >
>
>  Yes, it is.
>  http://linuxtv.org/hg/~anttip/af9015/

I couldn't compile this driver in my linux, maybe because the kernel is old:

> make
make -C /tmp/af9015-2eb574241ebe/v4l
make[1]: Entering directory `/tmp/af9015-2eb574241ebe/v4l'
No version yet, using 2.6.8-24-default
make[1]: Leaving directory `/tmp/af9015-2eb574241ebe/v4l'
make[1]: Entering directory `/tmp/af9015-2eb574241ebe/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.8
File not found: /lib/modules/2.6.8-24-default/build/.config at
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** [.config] Error 2
make[1]: Leaving directory `/tmp/af9015-2eb574241ebe/v4l'
make: *** [all] Error 2

But I was able to compile it in a kubuntu running in a virtual machine
in windows. Yes, now it recognizes the usb stick, and more or less
works. Kaffeine finds channels but then it only displays random lines
instead of the image.

With mplayer it's better, image is almost good, but it gets corrupted
(blocks appear) very often, which doesn't happen in Windows.

The main problem is that when mplayer is closed, the device doesn't
work anymore. It's like the /dev/dvb/* had gone. Unplugin and plugin
the stick doesn't fix the problem, it's necessary to reboot :(

-- 
Pepe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
