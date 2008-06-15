Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1K80TJ-0007Su-Bg
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 00:13:28 +0200
Received: by wa-out-1112.google.com with SMTP id n7so3753500wag.13
	for <linux-dvb@linuxtv.org>; Sun, 15 Jun 2008 15:13:02 -0700 (PDT)
Message-ID: <bb72339d0806151513x6b1d919bla92ad699f3d9fd63@mail.gmail.com>
Date: Mon, 16 Jun 2008 08:13:01 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48555CB0.7060606@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48555CB0.7060606@gmail.com>
Subject: Re: [linux-dvb] em28xx analog audio problems
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

On 16/06/2008, Raphael <rpooser@gmail.com> wrote:
> Hi all,
>  I'm using one of the more recent hg pulls of the v4l-dvb tree, and I
>  have a HVR-950 and pinnacle HD pro stick both working under the em28x
>  drivers recording ATSC.
>
>  For analog I can't seem to get audio working, even though the video
>  plays fine. I've read around that the device is supposed to register its
>  own /dev/dsp interface, but I only have one /dev/dsp, and no /dev/dsp1,
>  etc. Does anyone have a quick way to get analog sound working on this
>  card? I mainly use mythtv for recording.
>
>  Cheers,
>  Raphy
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
Hey,

I am not sure of the politics involved, but there seems to be active
development of the em28xx by Markus over here:
http://www.mcentral.de/wiki/index.php5/Em2880

hg pull from:
http://mcentral.de/hg/~mrec/v4l-dvb-kernel

cheers,
Owen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
