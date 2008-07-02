Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KE1r2-0002Hh-TJ
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 14:54:38 +0200
Received: by rv-out-0506.google.com with SMTP id b25so480485rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 02 Jul 2008 05:54:31 -0700 (PDT)
Message-ID: <d9def9db0807020554i5736ee79k114927cf9501b4c3@mail.gmail.com>
Date: Wed, 2 Jul 2008 14:54:31 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: aron@aron.ws
In-Reply-To: <ebb5820836d39cba9b5b05d4b058d06a@freepage.ro>
MIME-Version: 1.0
Content-Disposition: inline
References: <ebb5820836d39cba9b5b05d4b058d06a@freepage.ro>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx problems
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

Hi Aron,

On Wed, Jul 2, 2008 at 10:07 AM,  <aron@aron.ws> wrote:
> Hi!
>
> Sorry if I write to the wrong place.
>
> I have a problem with this driver... I've never used v4l so i don't really
> understand it.
> I want to use a USB 2.0 AV Grabber called GrabBeeX+
>
> It has an s-video, stereo and a composite video input.
> The sound and video are attached trough a saa7113h and EMP202 AC97 chip.
> The USB is attached to the em2800-2 chip.
>

is it really an em2800 chip? or em2820/em2840?

what does lsusb say?

-Markus


> I tried to load the module, after that I tried to compile it, but i still
> get the same effect.
>
> It does not create a video device file :(.
>
> Dmesg:
>
> Linux video capture interface: v2.00
> em28xx v4l2 driver version 0.0.1 loaded
> usbcore: registered new interface driver em28xx
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> usb 5-5: new high speed USB device using ehci_hcd and address 4
> usb 5-5: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver snd-usb-audio
>
> If you can please help me !
>
> Thanks!
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
