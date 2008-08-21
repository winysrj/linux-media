Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KWGjC-0000uo-JZ
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 22:25:56 +0200
Received: by nf-out-0910.google.com with SMTP id g13so169286nfb.11
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 13:25:50 -0700 (PDT)
Message-ID: <412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:25:50 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
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

On Thu, Aug 21, 2008 at 4:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Thu, Aug 21, 2008 at 4:13 PM, gothic nafik <nafik@nafik.cz> wrote:
>> One more question - what about radio and remote control via lirc? Can i
>> receive radio signal via antenna (for digital tv) i got in box with
>> notebook? Is today's version of dib0700 module able to create /dev/radio?
>
> The driver supports IR, but does not require LIRC, afaik -- try it
> yourself and find out if your device is supported.
>
> Radio is analog, thus, not supported by this driver.

FWIW:  Working on CX25843 analog support for the dib0700 based
Pinnnacle PCTV HD Pro was next on my list once I get the ATSC support
working.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
