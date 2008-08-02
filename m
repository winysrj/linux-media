Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KPCNt-0005Nv-LZ
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 10:22:47 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1464334rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 02 Aug 2008 01:22:36 -0700 (PDT)
Message-ID: <d9def9db0808020122v48f5eda5i1317dea245f61aea@mail.gmail.com>
Date: Sat, 2 Aug 2008 10:22:36 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: deloptes@yahoo.com
In-Reply-To: <262763.82849.qm@web53204.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.61.1217648208.25488.linux-dvb@linuxtv.org>
	<262763.82849.qm@web53204.mail.re2.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] kernel 2.6.26 em28xx_dvb wrong firmware or other
	issue with HVR-900 rev A
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

On Sat, Aug 2, 2008 at 9:34 AM, Emanoil Kotsev <deloptes@yahoo.com> wrote:
> Hello everybody,
>
> I wanted to try kernel 2.6.26 but couldn't start DVB tv - the error was
>
> firmware: requesting xc3028-v27.fw
> xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
>
> I read this firmware is related to HVR-950 but I have HVR-900 rev A which was fine with the v4l-dvb-experimental tree that I have been using with kenrel 2.6.20 and 2.6.24.
>
> Now I can not compile the v4l-dvb-experimental anymore.
>

don't use v4l-dvb-experimental anymore (it contains reverse engineered
code which hurts a couple of devices) and jump over to the latest
version.

$ hg clone http://mcentral.de/hg/~mrec/em28xx-new
$ cd em28xx-new
$ ./build.sh build
$ ./build.sh install
$ rm -rf /lib/modules/`uname -r`/kernel/drivers/media/video/em28xx
$ depmod -a

(you don't have to bother about firmwares when doing so).

cheers,
Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
