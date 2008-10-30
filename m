Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KveKv-0000JV-1H
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 21:41:46 +0100
From: Darron Broad <darron@kewl.org>
To: Michael Cutler <m@cotdp.com>
In-reply-to: <916433.23640.qm@web26103.mail.ukl.yahoo.com> 
References: <916433.23640.qm@web26103.mail.ukl.yahoo.com>
Date: Thu, 30 Oct 2008 20:41:41 +0000
Message-ID: <24272.1225399301@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] System freezes with 6 cx88 DVB-S adapters (5 x
	KWorld DVB-S 100, 1 x Hauppauge WinTV-HVR4000(Lite) DVB-S/S2)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <916433.23640.qm@web26103.mail.ukl.yahoo.com>, Michael Cutler wrote:

>Hello,

hi

=0A=0AI have quite an interesting problem on a system with 6 tuners, =
>basically the system 'locks up' completely after a short period of fairly i=
>ntensive use, only a power-cycle can bring the system back to life. I first=
> experienced this since building the system with Fedora Core 9 fully update=
>d (2.6.26.5-45.fc9.i686). I spotted some cx88 changes in the 2.6.27 release=
> notes and so upgraded to Fedora Core 10 / Rawhide and I am still experienc=
>ing the same problem on 2.6.27.4-58.fc10.i686.=0A=0AThe problem appears whe=
>n I run a simple script which controls all available tuners simultaneously =
>and tunes (szap) to a range of transponders before running tests (dvbsnoop =
>-s pidscan) on the content of each. This morning I grabbed the latest v4l-d=
>vb source tree (http://linuxtv.org/hg/v4l-dvb) and built it for my 2.6.27.4=
>-58.fc10.i686 kernel and I am still experiencing the same problem.=0A=0AUp =
>until this morning I have been limited to the 5 x KWorld DVB-S 100 tuners a=
>s the stock Fedora kernel didn't support the Hauppauge WinTV-HVR4000(Lite) =
>board. So the problem existed before the HVR4000 was included in the loop.=
>=0A=0AI have attached various bits of debug, its tricky to try and diagnose=
> the real cause as the machine completely freezes and doesn't respond to an=
>ything. I have tested the rest of the hardware (memtest, cpu burn-in-tests =
>etc.) and the system is otherwise perfectly stable. But if I run the script=
> to utilise all the tuners for a few minutes to an hour and the machine loc=
>ks up.=0A=0A

>Any ideas? suggestions?

This could be a PSU related problem, have you tried using
a more powerful PSU? Do you have the same problem with
less cards installed?

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
