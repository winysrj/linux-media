Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cp-out12.libero.it ([212.52.84.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sioux_it@libero.it>) id 1KVAT6-0004QH-4B
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 21:32:45 +0200
From: sioux <sioux_it@libero.it>
To: Adam DiCarlo <adam.dicarlo@gmail.com>
In-Reply-To: <a63d25c40808171520t9490d09jd71bdf711835f389@mail.gmail.com>
References: <a63d25c40808171520t9490d09jd71bdf711835f389@mail.gmail.com>
Date: Mon, 18 Aug 2008 21:31:57 +0200
Message-Id: <1219087917.5182.10.camel@sioux-desktop>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Can't compile saa7134_alsa on generic ubuntu	kernel
	(Hardy)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2106651471=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============2106651471==
Content-Type: multipart/alternative; boundary="=-uR06Av2zviYM5DBjkhVj"


--=-uR06Av2zviYM5DBjkhVj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Yes it helps... even if I had some problems with saa7134-dvb & saa7134
modules (loading that modules, I got complains about versions
disagrees).

I suggest to follow that procedure with kernel above => 2.6.25 or
waiting for intrepid.
Here my custom 2.6.25-6-sioux kernel is ok over a hardy release.

Hope this helps too.

Sioux.
_______________________________




> Hi, but I saw this post and thought my solution for compiling the
> GadgetLabs wavepro ALSA driver on Ubuntu 8.04 (x86_64) might be of
> use. I used a mainline kernel to do it, however.
> 
> See https://answers.launchpad.net/ubuntu/+question/35767
> 
> Hope this helps!
> 
> Adam
> 
> 
> Original message from Alexey Vinogradov:
> 
> Hello.
> 
> I've downloaded the sources of v4l-dvb and built them (I have A16D
> tuner which is not supported in "main" kernel). However, saa7134-alsa
> wasn't built. "make xconfig" also had this module unchecked (and
> unavailable to check).
> 
> I've found that this is because of "ubuntu" way of building system:
> the generic kernel config file doesn't has ALSA subsystem checked.
> Actually you have to install two modules: linux-image and
> linux-ubuntu-modules. First contains "minimal" kernel with just
> essential options - and .config file corresponding to it.
> linux-ubuntu-modules contains everything else - including all ALSA
> staff, etc.
> 
> The comment in media/saa7134/BOM said:
> 
> #
> # All of the saa7134 sources were copied directly from the 2.6.24 kernel.
> #
> # The ALSA depedent modules must be built in LUM since ALSA is
> # disabled in the kernel. Not all of the saa7134 modules are depedent on
> # ALSA, but it just seemed simpler to grab the whole pile.
> #
> # Note that the compilation of the saa7134 sources is also dependent on
> # the kernel headers packages containing some internal header files
> # from the drivers/media directories.
> #
> # Tim Gardner Apr 3, 2008.
> 
> So, my problem is that I can't build v4l-dvb saa7134-alsa module
> because ALSA is disabled in kernel.
> 
> If I enable the alsa in kernel config, it said this during stage 2 of
> building modules:
> 
> WARNING: "snd_pcm_lib_ioctl"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_format_big_endian"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_format_signed"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_format_width"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_period_elapsed"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_stop"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_format_physical_width"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_hw_constraint_step"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_hw_constraint_integer"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_card_register"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_set_ops"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_pcm_new"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_ctl_add"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_ctl_new1"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_card_new"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> WARNING: "snd_card_free"
> [/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
> 
> The module after such warning IS compiled - but cause segmentation
> fault, and is unusable because of it.
> 
> I believe that I need to mess some way the v4l-dvb with sources of
> linux-ubuntu-modules - to point some way that the ALSA is exists, and
> it is not in the kernel. but in the ubuntu-modules.
> 
> Am I right?
> 
> How to do it?
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--=-uR06Av2zviYM5DBjkhVj
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.18.3">
</HEAD>
<BODY>
Yes it helps... even if I had some problems with saa7134-dvb &amp; saa7134 modules (loading that modules, I got complains about versions disagrees).<BR>
<BR>
I suggest to follow that procedure with kernel above =&gt; 2.6.25 or waiting for intrepid.<BR>
Here my custom 2.6.25-6-sioux kernel is ok over a hardy release.<BR>
<BR>
Hope this helps too.<BR>
<BR>
Sioux.<BR>
_______________________________<BR>
<BR>
<BR>
<BR>
<BLOCKQUOTE TYPE=CITE>
<PRE>
Hi, but I saw this post and thought my solution for compiling the
GadgetLabs wavepro ALSA driver on Ubuntu 8.04 (x86_64) might be of
use. I used a mainline kernel to do it, however.

See <A HREF="https://answers.launchpad.net/ubuntu/+question/35767">https://answers.launchpad.net/ubuntu/+question/35767</A>

Hope this helps!

Adam


Original message from Alexey Vinogradov:

Hello.

I've downloaded the sources of v4l-dvb and built them (I have A16D
tuner which is not supported in &quot;main&quot; kernel). However, saa7134-alsa
wasn't built. &quot;make xconfig&quot; also had this module unchecked (and
unavailable to check).

I've found that this is because of &quot;ubuntu&quot; way of building system:
the generic kernel config file doesn't has ALSA subsystem checked.
Actually you have to install two modules: linux-image and
linux-ubuntu-modules. First contains &quot;minimal&quot; kernel with just
essential options - and .config file corresponding to it.
linux-ubuntu-modules contains everything else - including all ALSA
staff, etc.

The comment in media/saa7134/BOM said:

#
# All of the saa7134 sources were copied directly from the 2.6.24 kernel.
#
# The ALSA depedent modules must be built in LUM since ALSA is
# disabled in the kernel. Not all of the saa7134 modules are depedent on
# ALSA, but it just seemed simpler to grab the whole pile.
#
# Note that the compilation of the saa7134 sources is also dependent on
# the kernel headers packages containing some internal header files
# from the drivers/media directories.
#
# Tim Gardner Apr 3, 2008.

So, my problem is that I can't build v4l-dvb saa7134-alsa module
because ALSA is disabled in kernel.

If I enable the alsa in kernel config, it said this during stage 2 of
building modules:

WARNING: &quot;snd_pcm_lib_ioctl&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_format_big_endian&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_format_signed&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_format_width&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_period_elapsed&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_stop&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_format_physical_width&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_hw_constraint_step&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_hw_constraint_integer&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_card_register&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_set_ops&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_pcm_new&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_ctl_add&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_ctl_new1&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_card_new&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: &quot;snd_card_free&quot;
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!

The module after such warning IS compiled - but cause segmentation
fault, and is unusable because of it.

I believe that I need to mess some way the v4l-dvb with sources of
linux-ubuntu-modules - to point some way that the ALSA is exists, and
it is not in the kernel. but in the ubuntu-modules.

Am I right?

How to do it?

_______________________________________________
linux-dvb mailing list
<A HREF="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>
<A HREF="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A>
</PRE>
</BLOCKQUOTE>
</BODY>
</HTML>

--=-uR06Av2zviYM5DBjkhVj--



--===============2106651471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2106651471==--
