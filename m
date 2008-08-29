Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KZ6u6-0003zI-TE
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 18:32:56 +0200
Received: by fg-out-1718.google.com with SMTP id e21so584328fga.25
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 09:32:51 -0700 (PDT)
Message-ID: <37219a840808290932n23165451nfcdfa6ded704713e@mail.gmail.com>
Date: Fri, 29 Aug 2008 12:32:51 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Matyas Sustik" <linux-dvb.list@sustik.com>
In-Reply-To: <48B822A9.6070400@sustik.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B822A9.6070400@sustik.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV 7
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

On Fri, Aug 29, 2008 at 12:24 PM, Matyas Sustik
<linux-dvb.list@sustik.com> wrote:
> I am using debian sid and attempts to load the cx23885 module fail:
>
> in dmesg:
> cx23885: Unknown parameter `car'
> (I use the card=4 option.)


No, you must have used a "car=4" option....  Next time read the error
message and it might help you figure out what you did wrong.


>
> The device:
> 02:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
>        Subsystem: DViCO Corporation Device d618
>        Flags: bus master, fast devsel, latency 0, IRQ 10
>        Memory at fbc00000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: [40] Express Endpoint, MSI 00
>        Capabilities: [80] Power Management version 2
>        Capabilities: [90] Vital Product Data <?>
>        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>        Capabilities: [100] Advanced Error Reporting <?>
>        Capabilities: [200] Virtual Channel <?>
>        Kernel modules: cx23885
>
> kernel version:
> 2.6.26-1-amd64
>
> Note that this module came with the debian package:
> linux-image-2.6.26-1-amd64      2.6.26-3
>
> 1.  Am I right that this is not supposed to happen?  May I conclude
> that the packaged module is incompatible with the kernel it is packaged for?
> If so, I can report this bug to Debian; but I want to make sure I have the
> concepts straight before they shoot me down saying it is linuxtv.org's fault.


No idea what you're talking about.  I dont see a bug anywhere.

FusionHDTV7 is not supported in 2.6.26.y -- you should use the
linuxtv.org modules from the development repository, instead.


> 2.  I tried recompiling the module(s) using sources from linuxtv.org.  I used
> http://linuxtv.org/hg/v4l-dvb but the created modules still reported unknown
> symbols:
> cx23885: disagrees about version of symbol videobuf_streamoff
> cx23885: Unknown symbol videobuf_streamoff


Did you follow the instructions for building modules from the
linuxtv.org repositories?

Did you reboot your machine before trying the new modules?

Is videobuf compiled in the kernel, or as a module?  (it should be a module)

Did you just try to select the driver you needed in the linuxtv.org
mercurial repository, or did you build everything?

Just follow the instructions exactly -- dont pick and choose, just
build the entire repository.  Dont use "make load" ever -- it is evil.
 Just reboot your computer.




> There are actually various other mercurial repos hosted on linuxtv.org, which
> one should I try next?


There are individual developer repositories hosted on linuxtv.org --
you should never use them unless you know that you explicitly need a
changeset from a developer repository that has not yet been merged.

Use v4l-dvb, and follow instructions exactly -- regardless of whether
you think you know what you're doing -- the build rules for v4l-dvb
must be followed exactly... but  NEVER USE MAKE LOAD.


FusionHDTV7 support will be present in Intrepid, which uses the 2.6.27 kernel.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
