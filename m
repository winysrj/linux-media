Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68] helo=smtp1.bethere.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett1@onetel.com>) id 1JOyQY-0007xi-B8
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 17:56:14 +0100
Message-Id: <943AD9DC-0D82-4D86-B206-C1718A34EF3B@onetel.com>
From: Tim Hewett <tghewett1@onetel.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Tue, 12 Feb 2008 16:54:47 +0000
Cc: Tim Hewett <tghewett1@onetel.com>
Subject: Re: [linux-dvb] How to force adaptor order when using 2 DVB cards?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1851042858=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1851042858==
Content-Type: multipart/alternative; boundary=Apple-Mail-4--957695155


--Apple-Mail-4--957695155
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

I have adapted dvbstream to allow an adaptor's string ident (e.g. "ST  
STV0299 DVB-S" for a Technisat SkyStar 2 DVB-S PCI card, i.e. the  
string which appears in dmesg when the DVB frontend is added) to be  
passed as the argument to '-c' instead of just the adaptor number. e.g.:

dvbstream -n 4400 -o -f 10847 -p v -s 22000 -c "ST STV0299 DVB-S" -D 1  
0 258 2327 2328 2329

I have three SkyStar 2 cards, a Wideview USB, AF9005 USB and AF9015  
USB all in one PC, so they often are assigned to different card  
numbers on boot up. Using the ident string allows the device's actual  
adaptor number to be searched for each time.

The change also allows individual cards to be addressed if you have  
more than one of the same type, by adding the number to the end of the  
string delimited by ':', e.g. "ST STV0299 DVB-S:1" means the second  
SkyStar card, even if it is at card number 4 with the first being at  
card number 1 (with other devices in between). I need this because  
each card has a different LNB configuration, e.g. one has a diseqc  
switch. Fortunately the ordering of the PCI cards stays the same  
relative to each other, even if they aren't always assigned the same  
adaptor number.

The code is a total hack but if it helps then I can publish it,  
perhaps it could even migrate into MythTV etc.

There are various other hacks I've added to dvbstream, e.g. to avoid  
the consequences of constantly changing PID assignments (as happens  
sometimes for the BBC and ITV in the UK) you can specify a channel  
name, e.g. "BBC 2 England" and have dvbstream discover the PIDs in the  
same way as 'scan -c'.

HTH,

Tim.

> Yep, it's horrible. This is what I did, the adapters 0,1,2 are still
> there but MythTV is configured to used 4,5 and 6.
>
> # My own DVB hell
>
> # Twinhan DVB-S Card
> #
> KERNEL=="dvb[0-9].frontend0", ATTR{dev}=="212:3",
> symlink+="dvb/adapter4/frontend0", GROUP="video"
> KERNEL=="dvb[0-9].demux0", ATTR{dev}=="212:4",
> symlink+="dvb/adapter4/demux0", GROUP="video"
> KERNEL=="dvb[0-9].net0", ATTR{dev}=="212:7",
> symlink+="dvb/adapter4/net0", GROUP="video"
> KERNEL=="dvb[0-9].dvr0", ATTR{dev}=="212:5",
> symlink+="dvb/adapter4/dvr0", GROUP="video"
> #
> # Nova-T Stick 1
> #
> KERNEL=="dvb[0-9].frontend0", ATTRS{serial}=="4030489593",
> symlink+="dvb/adapter5/frontend0", GROUP="video"
>  KERNEL=="dvb[0-9].demux0", ATTRS{serial}=="4030489593",
> symlink+="dvb/adapter5/demux0", GROUP="video"
> KERNEL=="dvb[0-9].net0", ATTRS{serial}=="4030489593",
> symlink+="dvb/adapter5/net0", GROUP="video"
> KERNEL=="dvb[0-9].dvr0", ATTRS{serial}=="4030489593",
> symlink+="dvb/adapter5/dvr0", GROUP="video"
> #
> # Nova-T Stick 2
> #
> KERNEL=="dvb[0-9].frontend0", ATTRS{serial}=="4027844315",
> symlink+="dvb/adapter6/frontend0", GROUP="video"
> KERNEL=="dvb[0-9].demux0", ATTRS{serial}=="4027844315",
> symlink+="dvb/adapter6/demux0", GROUP="video"
> KERNEL=="dvb[0-9].net0", ATTRS{serial}=="4027844315",
> symlink+="dvb/adapter6/net0", GROUP="video"
> KERNEL=="dvb[0-9].dvr0", ATTRS{serial}=="4027844315",
> symlink+="dvb/adapter6/dvr0", GROUP="video"
>
> I'm not sure if gmail has split the lines above but each actual line
> should start with KERNEL.
>
> Sim
>

--Apple-Mail-4--957695155
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div>I have adapted dvbstream =
to allow an adaptor's string ident (e.g. "ST STV0299 DVB-S" for a =
Technisat SkyStar 2 DVB-S PCI card, i.e. the string which appears in =
dmesg when the DVB frontend is added) to be passed as the argument to =
'-c' instead of just the adaptor number. e.g.:</div><div><br =
class=3D"webkit-block-placeholder"></div><div>dvbstream -n 4400 -o -f =
10847 -p v -s 22000 -c "ST STV0299 DVB-S" -D 1 0 258 2327 2328 =
2329</div><div><br class=3D"webkit-block-placeholder"></div><div>I have =
three SkyStar 2 cards, a Wideview USB, AF9005 USB and AF9015 USB all in =
one PC, so they often are assigned to different card numbers on boot up. =
Using the ident string allows the device's actual adaptor number to be =
searched for each time.</div><div><br =
class=3D"webkit-block-placeholder"></div><div>The change also allows =
individual cards to be addressed if you have more than one of the same =
type, by adding the number to the end of the string delimited by ':', =
e.g.&nbsp;"ST STV0299 DVB-S:1" means the second SkyStar card, even if it =
is at card number 4 with the first being at card number 1 (with other =
devices in between). I need this because each card has a different LNB =
configuration, e.g. one has a diseqc switch. Fortunately the ordering of =
the PCI cards stays the same relative to each other, even if they aren't =
always assigned the same adaptor number.</div><div><br =
class=3D"webkit-block-placeholder"></div><div>The code is a total hack =
but if it helps then I can publish it, perhaps it could even migrate =
into MythTV etc.</div><div><br =
class=3D"webkit-block-placeholder"></div><div>There are various other =
hacks I've added to dvbstream, e.g. to avoid the consequences of =
constantly changing PID assignments (as happens sometimes for the BBC =
and ITV in the UK) you can specify a channel name, e.g. "BBC 2 England" =
and have dvbstream discover the PIDs in the same way as 'scan =
-c'.</div><div><br =
class=3D"webkit-block-placeholder"></div><div>HTH,</div><div><br =
class=3D"webkit-block-placeholder"></div><div>Tim.</div><div><br =
class=3D"webkit-block-placeholder"></div><div><blockquote type=3D"cite" =
class=3D""><span class=3D"Apple-style-span" style=3D"color: rgb(0, 0, =
0); font-family: Times; font-size: 16px; "><pre>Yep, it's horrible. This =
is what I did, the adapters 0,1,2 are still
there but MythTV is configured to used 4,5 and 6.

# My own DVB hell

# Twinhan DVB-S Card
#
KERNEL=3D=3D"dvb[0-9].frontend0", ATTR{dev}=3D=3D"212:3",
symlink+=3D"dvb/adapter4/frontend0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].demux0", ATTR{dev}=3D=3D"212:4",
symlink+=3D"dvb/adapter4/demux0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].net0", ATTR{dev}=3D=3D"212:7",
symlink+=3D"dvb/adapter4/net0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].dvr0", ATTR{dev}=3D=3D"212:5",
symlink+=3D"dvb/adapter4/dvr0", GROUP=3D"video"
#
# Nova-T Stick 1
#
KERNEL=3D=3D"dvb[0-9].frontend0", ATTRS{serial}=3D=3D"4030489593",
symlink+=3D"dvb/adapter5/frontend0", GROUP=3D"video"
 KERNEL=3D=3D"dvb[0-9].demux0", ATTRS{serial}=3D=3D"4030489593",
symlink+=3D"dvb/adapter5/demux0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].net0", ATTRS{serial}=3D=3D"4030489593",
symlink+=3D"dvb/adapter5/net0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].dvr0", ATTRS{serial}=3D=3D"4030489593",
symlink+=3D"dvb/adapter5/dvr0", GROUP=3D"video"
#
# Nova-T Stick 2
#
KERNEL=3D=3D"dvb[0-9].frontend0", ATTRS{serial}=3D=3D"4027844315",
symlink+=3D"dvb/adapter6/frontend0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].demux0", ATTRS{serial}=3D=3D"4027844315",
symlink+=3D"dvb/adapter6/demux0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].net0", ATTRS{serial}=3D=3D"4027844315",
symlink+=3D"dvb/adapter6/net0", GROUP=3D"video"
KERNEL=3D=3D"dvb[0-9].dvr0", ATTRS{serial}=3D=3D"4027844315",
symlink+=3D"dvb/adapter6/dvr0", GROUP=3D"video"

I'm not sure if gmail has split the lines above but each actual line
should start with KERNEL.

Sim
</pre><div><font class=3D"Apple-style-span" face=3D"Monaco"><span =
class=3D"Apple-style-span" style=3D"white-space: pre;"><br =
class=3D"webkit-block-placeholder"></span></font></div></span></blockquote=
></div></body></html>=

--Apple-Mail-4--957695155--


--===============1851042858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1851042858==--
