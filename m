Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rvm3000@gmail.com>) id 1JigRW-0008V2-Dm
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 03:46:44 +0200
Received: by an-out-0708.google.com with SMTP id d18so294125and.125
	for <linux-dvb@linuxtv.org>; Sun, 06 Apr 2008 18:46:26 -0700 (PDT)
Message-ID: <f474f5b70804061846o66a3126aidcde58b4889b926c@mail.gmail.com>
Date: Mon, 7 Apr 2008 03:46:26 +0200
From: rvm <rvm3000@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <47F90CA3.1090102@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <f474f5b70804021720i7926ea17q77b3ef551fb0841f@mail.gmail.com>
	<47F44538.2090508@iki.fi>
	<f474f5b70804051654h3ee0bdd5u6eb19db2ac626845@mail.gmail.com>
	<47F90CA3.1090102@iki.fi>
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

2008/4/6, Antti Palosaari <crope@iki.fi>:
> rvm wrote:
>
> > But I was able to compile it in a kubuntu running in a virtual machine
> > in windows. Yes, now it recognizes the usb stick, and more or less
> > works. Kaffeine finds channels but then it only displays random lines
> > instead of the image.
> >
> > With mplayer it's better, image is almost good, but it gets corrupted
> > (blocks appear) very often, which doesn't happen in Windows.
> >
> > The main problem is that when mplayer is closed, the device doesn't
> > work anymore. It's like the /dev/dvb/* had gone. Unplugin and plugin
> > the stick doesn't fix the problem, it's necessary to reboot :(
> >
>
>  Can you test again. I did some updates and hopefully it will fix that last
> problem.

Yes, that problem seems fixed. Thanks.

Still I'm getting the video (and audio) corrupted, could it be because
of the firmware? I used this one:
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

-- 
Pepe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
