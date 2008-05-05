Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1Jsxdu-0007ge-2L
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 12:09:58 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: "Eduard Huguet" <eduardhc@gmail.com>
Date: Mon, 5 May 2008 12:09:19 +0200
References: <617be8890805050034q5ce1734dq3b10c5af3aac3ac7@mail.gmail.com>
In-Reply-To: <617be8890805050034q5ce1734dq3b10c5af3aac3ac7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805051209.19459.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Finally got Avermedia A700 (DVB-S Pro) working!
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

On Montag, 5. Mai 2008, Eduard Huguet wrote:
> Hi,
>     Just a quick note: the Avermedia DVB-S Pro (A700) is yet working on my
> computer, finally. I'm using your lastest patch set (from May 2), but what
> really did the trick was using an enhanced frequency file for Astra 19.2
> (got it from http://joshyfun.peque.org/transponders/kaffeine.html), instead
> of the standard one provided in /usr/share/dvb/dvb-s/Astra 19.2.
>
>    With the standard file the driver didn't work, as usual. However, as the
> driver seemed to be working for other people I spent some time googling for
> problems related to DVB-S, Kaffeine, etc..., and I found that page which
> provides an extensive reference for the satellites our there in Kaffeine
> format. I just tried the one for Astra 19.2, and to my surprise it worked
> perfectly :D !
>
>    So: the driver works, I suppose this is good news :D for you, Matthias.
> However, as I'm a complete noob regarding DVB-S I don't know if the driver
> SHOULD work and detect all available channels using only the default Astra
> 19.2 file, or else really that file is incomplete and should not be used.

This is good news.
I think to trace this issue you should send both channels.conf files to 
compare them.

>
>    Tonight I'll move the card to my MythTV computer and try the driver in
> it. This one is running Gentoo 64, so I'll provide feedback on that arch
> too. By now, the card is running perfectly on x86, Gentoo kernel 2.6.24 and
> Kaffeine.
>
>    Just a little note: the lastest patch doesn't compile "as is": in
> saa7134-dvb.c, the function "mt312_attach()" is called and it's not defined
> anywhere. I figured out the correct one was "vp310_mt312_attach()" so I
> changed it. Now the driver compiles and works fine :D.

Fixed this.

> You really did a great job, Matthias
Thank you.


Matthias


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
