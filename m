Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KvXPQ-0006Kt-8t
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 14:17:57 +0100
Received: by ey-out-2122.google.com with SMTP id 25so220656eya.17
	for <linux-dvb@linuxtv.org>; Thu, 30 Oct 2008 06:17:53 -0700 (PDT)
Message-ID: <412bdbff0810300617j54ffc088we2885e9936a34d66@mail.gmail.com>
Date: Thu, 30 Oct 2008 09:17:52 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Vedran Rodic" <vrodic@gmail.com>
In-Reply-To: <8ccf2e9c0810300245v64954641yafe9e7b29f243e84@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8ccf2e9c0810300245v64954641yafe9e7b29f243e84@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Gigabyte U7000 (dvb_usb_dib0700) power management
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

On Thu, Oct 30, 2008 at 5:45 AM, Vedran Rodic <vrodic@gmail.com> wrote:
> Hello.
>
> I have a gigabyte u7000 USB dvb-t receiver with dib0700 and mt2060.
>
> It's working fine (debian linux 2.6.26-1 stock kernel, firmware
> dvb-usb-dib0700-1.10.fw or dvb-usb-dib0700-03-pre1.fw), but the device
> is not powering down when the frontend and other device files are
> closed.
> The device has a LED diode indicating power state and it's warm all
> the time in Linux after the driver has been loaded. In  Windows the
> LED is only on when the TV Viewing software is used, and the device is
> cold when not used.
>
> I've tried unloading all dvb/dib/tuner etc modules but the LED is
> still on. Are there any sysfs/proc control files to power it down when
> not used? Should I try the latest v4l-dvb tree?

Verdan,

I don't know about the mt2060, but this is actually really common for
USB tuners in linux-dvb.  I have patches pending for both the xc5000
and xc3028 to properly power down the tuner properly.  It's also
possible that the tuner is being powered down but the demodulator is
not (I submitted a patch for the s5h1411 last week in fact).

>From an end-user perspective, you shouldn't have to take any special
measures other than closing the application that uses the device (the
tuner and demod are put to sleep a couple of seconds after the
frontend is closed).  If the driver properly implements the
foo_sleep() callback, it should "just work".

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
