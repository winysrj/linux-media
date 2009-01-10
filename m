Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.citynetwork.se ([62.95.110.81] helo=smtp05.citynetwork.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reklam@holisticode.se>) id 1LLcWI-0005zm-Lt
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 13:00:51 +0100
From: =?iso-8859-1?Q?M=E5rten_Gustafsson?= <reklam@holisticode.se>
To: "'Manu Abraham'" <abraham.manu@gmail.com>
References: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org>
	<26D75E582F22456998AE6365440ACEC6@xplap>
	<49673D65.9030404@gmail.com>
Date: Sat, 10 Jan 2009 13:00:13 +0100
Message-ID: <CE5D9398D87E43CDA896BFFDF0CBEE1D@xplap>
MIME-Version: 1.0
In-Reply-To: <49673D65.9030404@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
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

 =

> Fr=E5n: Manu Abraham [mailto:abraham.manu@gmail.com] =

> Skickat: den 9 januari 2009 13:05
> Till: M=E5rten Gustafsson
> Kopia: linux-dvb@linuxtv.org
> =C4mne: Re: [linux-dvb] Compiling mantis driver on 2.6.28
> =

> M=E5rten Gustafsson wrote:
> > I tried downloading and compiling from s2-liplianin repository.
> > Unfortunately the driver doesn't work at all with AzureWave =

> AD-CP300, =

> > frontend tda10021 is identified instead of tda10023.
> =

> The official mantis repository is at =

> http://jusst.de/hg/mantis. It contains the latest mantis =

> related changes. =

> =

> Please do test and report.

I downloaded latest from jusst.de and compiled. Oberve that I have an older
kernel:
$ uname -a
Linux ubuntu-htpc 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC 2008
x86_64 GNU/Linux more10@ubuntu-htpc:

Correct frontend is reported. Scanning in Kaffeine quits after scanning a
few channels. w_scan with standard switches scans a large number of
channels, but i get tieout in filter scan resulting in the channels name not
being reported. w_scan with -F switch works better, but about a quarter of
the channels now have no name.

Tuning to a radio channel in Kaffein results in 5 seconds of distortion,
then the machine hangs, leaving my ext2 file system corrupt :-). =


And of course Kaffeine reports that all my tv channels are scramled and
quitting.

> =

> =

> Regards,
> Manu
> =

> =


M=E5rten


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
