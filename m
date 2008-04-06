Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.247])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greg.d.thomas@gmail.com>) id 1JiWzW-00072x-Vz
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 17:41:12 +0200
Received: by an-out-0708.google.com with SMTP id d18so248674and.125
	for <linux-dvb@linuxtv.org>; Sun, 06 Apr 2008 08:40:54 -0700 (PDT)
Message-ID: <e28a31000804060840y126b7afdp67ef934724d6dda7@mail.gmail.com>
Date: Sun, 6 Apr 2008 16:40:54 +0100
From: "Greg Thomas" <Greg@TheThomasHome.co.uk>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.64.0804061551510.23914@pub4.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <e28a31000804060623u141fc8e2hd6405809ce6fe477@mail.gmail.com>
	<Pine.LNX.4.64.0804061551510.23914@pub4.ifh.de>
Subject: Re: [linux-dvb] WinTV-NOVA-TD & low power muxes
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

On 06/04/2008, Patrick Boettcher <patrick.boettcher@desy.de> wrote:
[Re-arranged to reflect the order I tried it in, and resent to the list]
> Hi Greg,
>
>  There have been some updates some time ago to improve the sensitivity. Can
> you try a more recent driver (v4l-dvb from hg or 2.6.25).

I tried the latest drivers from http://linuxtv.org/hg/v4l-dvb; a
couple of compile time warnings I'm sure you're aware of;

include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:211: warning: passing argument 2 of '__memcpy'
discards qualifiers from pointer target type

and similar, but other than that, compiled and installed OK. However,
this made no difference to the channels it could find.

>  Do you have the possibility to try the device with the Hauppauge Windows
> driver?
>
>  The linux driver is maybe not configuring the device optimally, because it
> is more generic, whereas the manufacturer's driver is specifically for this
> particular device.

After trying the latest drivers, I had a go under Windows; exactly the
same set of channels. I just guess the Nova-TD isn't that sensitive. I
may just have to look at boosting my signal, somehow :(

Thanks for the help,

Greg

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
