Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JZDr1-0004gB-2d
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 00:26:00 +0100
Received: by el-out-1112.google.com with SMTP id o28so1457397ele.2
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 16:25:47 -0700 (PDT)
Message-ID: <37219a840803111625x3079e56apf38b7122979fc11d@mail.gmail.com>
Date: Tue, 11 Mar 2008 19:25:43 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Jarryd Beck" <jarro.2783@gmail.com>
In-Reply-To: <abf3e5070803111405v5d65d531mbff0649df14226d3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
	<47D49309.8020607@linuxtv.org>
	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>
	<47D4B8D0.9090401@linuxtv.org>
	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
	<47D539E8.6060204@linuxtv.org>
	<abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>
	<47D5AF38.90600@iki.fi>
	<abf3e5070803111405v5d65d531mbff0649df14226d3@mail.gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

On Tue, Mar 11, 2008 at 5:05 PM, Jarryd Beck <jarro.2783@gmail.com> wrote:
> >  Can you take logs with vendor WHQL driver and sent for further analysis?
>  >  http://www.afatech.com/EN/support.aspx
>  >
>  >  Antti
>  >
>  >  --
>  >  http://palosaari.fi
>  >
>
>  For some reason windows didn't like that driver. When I used the installer
>  nothing happened, and when I used device manager it said this folder
>  contains no information about your device.
>  So I made a snoop with the driver on the CD, I hope it's good enough.
>
>  I uploaded the snoop to
>  http://download.yousendit.com/2B0B420876BFB959
>
>  While it was snooping, I plugged it in, tuned the card to a tv channel
>  and pulled it out as quick as I could.
>  If it helps, the channel was channel 7, sydney, australia.


This helps.....  I can tell that your tda18211 is located at 0xC0, and
it contains 0x83 in its ID register.  This is the same ID byte that
the tda18271c1 uses to identify itself -- hopefully that implies
driver compatability, but we won't know for sure until you try it.

The windows driver is only using the primary sixteen registers  --  I
don't know if the device even HAS the 23 extended registers that the
tda18271 has...  The driver that you're running does not seem to touch
the extended registers at all.  It's possible that the driver is
simply blasting the register bytes to the tuner, without doing any
calibration explicitly -- that could explain the 16 byte blasts
without any transactions to the extended registers.... not sure --
this is all speculation.

One thing I can say -- the Linux tda18271 driver should be able to
detect your tuner at 0xC0  (0x60)  as a tda18271c1 -- It's worth a
try, and could certainly be possible that the driver *may* work as-is,
although I suspect that some tweaking will be needed.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
