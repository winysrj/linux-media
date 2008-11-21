Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L3a2J-0005Vr-Ld
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 18:43:22 +0100
Received: by ey-out-2122.google.com with SMTP id 25so419210eya.17
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 09:43:16 -0800 (PST)
Message-ID: <412bdbff0811210943l1d9c6b49j95ff79d32d98a479@mail.gmail.com>
Date: Fri, 21 Nov 2008 12:43:16 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840811210934q1809fa5r7c51cff56a761d25@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
	<37219a840811210934q1809fa5r7c51cff56a761d25@mail.gmail.com>
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

On Fri, Nov 21, 2008 at 12:34 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> With the powerful systems around in this day & age, the gain of using
> hardware PID filters is hardly noticeable.
>
> Then again, you like to tweak things to the ultimate flexibility, and
> this is a good case for tweaking.

While that's generally true, with limited resources my time might be
better spent finishing the work getting xc5000 tuning time down from
3200ms to 300.  :-)

> While a system with a single usb2 stick will not be taxed at all by
> software PID filtering, there might be a slight performance
> enhancement in a system with 7 or 8 usb2 sticks using hardware PID
> filters rather than software.
>
> On the other hand, a device with hardware PID filters can be used on a
> USB1.1 port, which would normally not provide enough bandwidth for
> full transport using software filtering.
>
> So yes, there is a gain in using hardware PID filters, but 90% of the
> users would never notice the difference.

This is entirely consistent with what I thought.  Figured there was no
harm in soliciting opinions of others though.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
