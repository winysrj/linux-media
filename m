Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1L3Zty-0004M4-Er
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 18:34:44 +0100
Received: by ey-out-2122.google.com with SMTP id 25so417656eya.17
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 09:34:38 -0800 (PST)
Message-ID: <37219a840811210934q1809fa5r7c51cff56a761d25@mail.gmail.com>
Date: Fri, 21 Nov 2008 12:34:38 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hardware pid filters: are they worth it?
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

On Fri, Nov 21, 2008 at 12:28 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> Hello,
>
> I am doing some driver work, and the USB device I am working on has
> hardware pid filter support.
>
> Obviously if I don't implement such support, the kernel will do the
> pid filtering.
>
> Does anyone have any experience with hardware pid filters, and have
> they provided any signficant/visible benefit over the kernel pid
> filter (either from a performance perspective or power consumption)?
> This is aside from the known benefit that some streams would fit into
> a full speed USB whereas before you might have required high speed
> without the hardware pid filter.
>
> It's probably a good thing to implement in general for completeness,
> but if there isn't any power or performance savings then I'm not sure
> it's worth my time.
>
> Opinions welcome,
>
> Devin

With the powerful systems around in this day & age, the gain of using
hardware PID filters is hardly noticeable.

Then again, you like to tweak things to the ultimate flexibility, and
this is a good case for tweaking.

While a system with a single usb2 stick will not be taxed at all by
software PID filtering, there might be a slight performance
enhancement in a system with 7 or 8 usb2 sticks using hardware PID
filters rather than software.

On the other hand, a device with hardware PID filters can be used on a
USB1.1 port, which would normally not provide enough bandwidth for
full transport using software filtering.

So yes, there is a gain in using hardware PID filters, but 90% of the
users would never notice the difference.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
