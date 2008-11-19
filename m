Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greblus@gmail.com>) id 1L2oGt-0002ZQ-Ll
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 15:43:13 +0100
Received: by wf-out-1314.google.com with SMTP id 27so3996764wfd.17
	for <linux-dvb@linuxtv.org>; Wed, 19 Nov 2008 06:43:06 -0800 (PST)
Message-ID: <912f87b30811190643o22c91f5cq65576b81a137e1e1@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:43:04 +0100
From: "=?ISO-8859-2?Q?Wiktor_Gr=EAbla?=" <greblus@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20081119122718.425517BD53@ws5-10.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081119122718.425517BD53@ws5-10.us4.outblaze.com>
Subject: Re: [linux-dvb] HVR 850 analog
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

Hi.

I've similar configuration but I use tvtime patched by Markus
Rechberger to support HVR's audio directly. Tvtime gives better video
quality and requires less cpu.

It can be found here:

http://mcentral.de/hg/~mrec/tvtime

I don't know if the changes were pushed upstream (it seems that the
development of tvtime stopped in 2005).

Cheers,
W.

2008/11/19 Paul Guzowski <guzowskip@linuxmail.org>:
> Hello all:
>
> I finally succeeded by using MPlayer and passing a bunch of parameters to it from the command line.  Once I got it working I set up a launcher with the entire command string so that all I had to do is hit the button on my desktop to show TV.  The command I am using is:
>
> mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3
>
> This gives me a simple window tuned to NTSC channel three.  I change the channel on my cable box and change the volume with either the computer or cable box or both.


-- 
Talkers are no good doers.
http://greblus.net/djangoblog/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
