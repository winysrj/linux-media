Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.acc.umu.se ([130.239.18.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nikke@acc.umu.se>) id 1Kum0o-00070I-7c
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 11:41:23 +0100
Date: Tue, 28 Oct 2008 11:41:09 +0100 (MET)
From: Niklas Edmundsson <nikke@acc.umu.se>
To: =?iso-8859-1?Q?M=E5rten_Gustafsson?= <reklam@holisticode.se>
In-Reply-To: <44DBF3264FE24C6CBCD74E9A61EB414A@xplap>
Message-ID: <Pine.GSO.4.64.0810281132250.5603@hatchepsut.acc.umu.se>
References: <mailman.1.1224410403.28932.linux-dvb@linuxtv.org>
	<44DBF3264FE24C6CBCD74E9A61EB414A@xplap>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis 2033 dvb-tuning problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, 23 Oct 2008, M=E5rten Gustafsson wrote:

> Nikke
>
> I tried your patch, and it "improve" things a bit. Kaffeine is able to sc=
an
> a few channels now without any entries in /var/log/messages. w_scan finds=
 a
> few frequencies, but no services. Scan results are different between scan=
s.
> w_scan works "better" if timeout settings are increased.
>
> The channels found by Kaffeine are not viewable, there is something movin=
g,
> but I guess the driver is unable to descramble the signal.
>
> My system is an Ubuntu 8.10 amd64. The network is ComHem and the CI is fr=
om
> Conax. I also have the AzureWave AD-CP300.

I'm running it on the Debian 2.6.18 kernel, viewing free channels (our =

provider Kommunicera gives us the standard channels via analog and =

unencrypted DVB-C).

Scanning still sucks for me, but since I did the initial scan using a =

borrowed DVB-C card (something 1500 something) I'm happy for the =

moment. It would be nice if scanning worked tho, then I might be able =

to run myth-setup to completion (currently I use mplayer combined with =

at to record programs).

I'd suggest you find someone that can provide you with a =

ComHem channels.conf to circumvent the scanning problem for now...

> Since this is an improvement I agree with you, Manu should apply the patc=
h.

He said he will, I suspect he's just not had the time to do it.

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> On Wed, 15 Oct 2008, Hans Bergersen wrote:
>
>> Hi,
>>
>
>> I have got a Twinhan vp-2033 based card. I run Ubuntu 8.04. I have
>> downloaded the driver from http://jusst.de/hg/mantis and it compiled
>> just fine. But when i try to tune a channel the tuning fails. It is
>> a newer card with the tda10023 tuner but when the driver loads it
>> uses the tda10021. What do I have to do to make it use the right
>> tuner? Can i give some options when compiling or when loading the
>> module?
> <snip>
>> Any ideas?
>
> Try the attached patch which fixes this for my Azurewave AD-CP300 (at
> least last time I compiled it).
>
> I've sent it to Manu and he was going to apply it, but it hasn't shown
> up on http://jusst.de/hg/mantis/ yet...
>
>
> /Nikke
>


/Nikke
-- =

-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
  Niklas Edmundsson, Admin @ {acc,hpc2n}.umu.se      |     nikke@acc.umu.se
---------------------------------------------------------------------------
  If turning it on doesn't help, plug it in.
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
