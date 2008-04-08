Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JjKxD-0003Uk-Au
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 23:02:15 +0200
Received: by el-out-1112.google.com with SMTP id o28so1618919ele.2
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 14:02:02 -0700 (PDT)
Message-ID: <c8b4dbe10804081402y71bb0de4q6ee3d928b8aaf1c9@mail.gmail.com>
Date: Tue, 8 Apr 2008 22:02:01 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Paolo Pettinato" <p.pettinato@gmail.com>
In-Reply-To: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with unsupported DVB-T usb stick (CE6230)
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

On Tue, Apr 8, 2008 at 7:25 PM, Paolo Pettinato <p.pettinato@gmail.com> wrote:
> Hi all,
>  I'm new to this mailing list so please excuse me if I do some mistakes
>  :) also I feel sorry for my English :)
>  I've recently bought a cheap DVB-T dongle on ebay. Works like a charm
>  on windows XP, but it seems that there's no support on linux (I've
>  done some searching).
>  The vendorid:productid codes are 8086:9500. On "Device Manager" it is
>  listed as "CE6230 Standalone Driver (BDA)". On its properties, it says
>  that it's manufactured by Realfine Ltd and is on Location 0
>  (CE9500B1).
>  Since I can't stand the fact that I can't use some hardware on linux,
>  I'm asking two questions:
>  1. Has any work be done to support this device (or similar ones, like
>  - I think - the "AVerMedia USB2.0 DVB-T A310")?
>  2. If so, how can I help further developing?
>
>  I'm a student in computer engineering, so I won't mind spending some
>  time on driver developing (though I have never done till now).
>  Paolo

Hi,

I'm not aware of any drivers for the CE6230 (in fact, this is the
first device I've heard of that uses it so far). Someone will have to
try and get the docs from Intel - I don't think these are exactly
simple devices. (They have a full programmable 8051 microprocessor
core on-chip in addition to stuff like a seperate hardware PID filter
and a fairly intelligent demodulator. OTOH, the demodulator is
probably based on one of the Zarlink designs, which makes life
slightly easier).

>  CE6230 is a demodulator of Intel
>  (http://www.intel.com/design/celect/demodulators/ce6230.htm) . Its seems to
>  be a successor of the Zarlink MT352/MT353 (Intel bought Zarlink some time
>  ago).
>
>  So you should have a look on the 352/353 drivers, maybe there are some
>  parallels.

Yep - it's an integrated USB interface and demodulator on a chip. They
seem to be becoming more common these days, possibly due to potential
cost savings. Probably has more in common with the ZL10353/CE6353 and
company - the MT352/MT353 had been throughly obsoleted by them by the
time Intel bought out Zarlink, to the point that Intel didn't even
bother giving them new Intel part numbers.

Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
