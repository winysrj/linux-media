Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KWGme-0001Yf-PB
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 22:29:30 +0200
Received: by fg-out-1718.google.com with SMTP id e21so85033fga.25
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 13:29:25 -0700 (PDT)
Message-ID: <37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:29:25 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
	<412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

On Thu, Aug 21, 2008 at 4:25 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Thu, Aug 21, 2008 at 4:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> On Thu, Aug 21, 2008 at 4:13 PM, gothic nafik <nafik@nafik.cz> wrote:
>>> One more question - what about radio and remote control via lirc? Can i
>>> receive radio signal via antenna (for digital tv) i got in box with
>>> notebook? Is today's version of dib0700 module able to create /dev/radio?
>>
>> The driver supports IR, but does not require LIRC, afaik -- try it
>> yourself and find out if your device is supported.
>>
>> Radio is analog, thus, not supported by this driver.
>
> FWIW:  Working on CX25843 analog support for the dib0700 based
> Pinnnacle PCTV HD Pro was next on my list once I get the ATSC support
> working.

Devin,

Lets sync up when you get to that point -- I have a good chunk of code
written that will add analog support to the dvb-usb framework as an
optional additional adapter type.

Hopefully I'll get more work done on it before then, but if not, this
is at least a good starting point.

The idea is to add support to the framework so that the sub-drivers
(such as dib0700, cxusb et al) can all use the common code.

CX25843 is already supported, just the dvb-usb framework currently
lacks a v4l2 interface.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
