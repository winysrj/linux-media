Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KWGem-0000Hn-42
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 22:21:21 +0200
Received: by fg-out-1718.google.com with SMTP id e21so83479fga.25
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 13:21:15 -0700 (PDT)
Message-ID: <37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:21:15 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "gothic nafik" <nafik@nafik.cz>
In-Reply-To: <48ADCC81.5000407@nafik.cz>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
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

On Thu, Aug 21, 2008 at 4:13 PM, gothic nafik <nafik@nafik.cz> wrote:
> One more question - what about radio and remote control via lirc? Can i
> receive radio signal via antenna (for digital tv) i got in box with
> notebook? Is today's version of dib0700 module able to create /dev/radio?

The driver supports IR, but does not require LIRC, afaik -- try it
yourself and find out if your device is supported.

Radio is analog, thus, not supported by this driver.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
