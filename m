Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:39178 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0CRKBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 06:01:01 -0400
Received: from [188.107.127.143] (helo=[192.168.1.22])
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <besse@motama.com>)
	id 1NsCXE-0003mr-7j
	for linux-media@vger.kernel.org; Thu, 18 Mar 2010 11:01:00 +0100
Message-ID: <4BA1F9C6.3020807@motama.com>
Date: Thu, 18 Mar 2010 11:00:38 +0100
From: Andreas Besse <besse@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Problems with ngene based DVB cards (Digital Devices Cine S2
 Dual DVB-S2 , Mystique SaTiX S2 Dual)
References: <4BA10639.3000407@motama.com>
In-Reply-To: <4BA10639.3000407@motama.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We are now able to reproduce the problem faster and easier (using the
patched version of szap-s2 and the scripts included in the tar.gz :
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17334
and
http://cache.gmane.org//gmane/linux/drivers/video-input-infrastructure/17334-001.bin
)

0) su -c "rmmod ngene && modprobe ngene one_adapter=0"

1) ./run_szap-s2_adapter0.sh | grep Delay

2) in parallel to 1)

szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r -Q 7

(better: by adding "-Q" the program is terminated, and all devices are
closed after approx. 8 to 9 secs)

=> while 2) is running 1) will show increased tuning times

Delay : 0.541970
Delay : 0.606943
Delay : 1.410069 [ HERE 2) was started ]
Delay : 1.369592
Delay : 1.261879
Delay : 1.766680

3) after 2) has terminated simply let 1) continue for 30-40 iterations. you
will see

..
Delay : 1.845793
Delay : 1.772285
Delay : 2.045703
Delay : 1.817985
Delay : 0.982030
Delay : 1.769856
Delay : 1.769782
Delay : 0.537857
Delay : 21.628382

4) At this point, immediately press Ctrl-C and restart 1) - you will see

Delay : 0.577599
Delay : 0.549717
Delay : 0.593816
Delay : 0.593758
Delay : 0.549584
Delay : 0.546012

==> BAD: Problem seems to happen due to one adapter being opened and closed
again

==> GOOD: we are now able to easily and quickly reproduce both problems
without
Ctrl-C

thanks for your help,
Andreas Besse

Andreas Besse wrote:
> Hello,
>
> we discovered several problems with the ngene based dual DVB cards. The
> problems occur with the Digital Devices Cine S2 Dual DVB-S2 device
> (Linux4Media cineS2 DVB-S2 Twin Tuner), the clones like Mystique SaTiX
> S2 Dual should also be affected.
>
> We are using the ngene drivers from the linuxtv repository
> http://linuxtv.org/hg/v4l-dvb and the firmware version 15 provided by
> Digital Devices.
>
> *Setup* *******************************************
>
> OpenSuse Linux 11.0
> Linux anna 2.6.25.20-0.5-pae #1 SMP 2009-08-14 01:48:11 +0200 i686 i686
> i386 GNU/Linux
> DVB drivers: http://linuxtv.org/hg/v4l-dvb (ngene)
> 2e0444bf93a4 (changeset 14233:2e0444bf93a4, date: Mon Feb 22 10:58:43
> 2010 -0300)
>
> module loaded with
>   modprobe ngene one_adapter=0
>
> *Usage* *******************************************
>
> We slightly modified the latest version of szap-s2 (available from
> http://mercurial.intuxication.org/hg/szap-s2/ ); see attached .tar.gz
>
> tar xvfz modified_szap_s2.tar.gz
>
> make
>
> Most importantly, the modified version prints out the total delay in
> seconds of main() to allow for easier debugging.
>
> *Problem A* *******************************************
>
> Two running instance of szap-s2 are used:
>
> a) one for changing channels between "Das Erste" (Astra 19.2E) and
> "ZDF" (Astra 19.2E)
>
> b) the other one for recording from "Das Erste" (or any other channel)
>
> Result:
>
> When only a) is running, channel tuning times between the two
> different transponders of "Das Erste" and "ZDF" are around 0.5
> secs. This is really good.
>
> However, when b) is started in parallel, these times increase to 1.5
> to 1.8 seconds. This is not good.
>
> How to reproduce?
>
> 1) in one shell, run
>
>  ./run_szap-s2_adapter0.sh | grep Delay
>
> You will see
>
> Delay : 0.560508
> Delay : 0.545771
> Delay : 0.609781
> Delay : 0.593796
> Delay : 0.649772
> Delay : 0.614023
> ..
>
> 2) in parallel in another shell, run
>
> ./szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r
>
> Immediately, you will see in 1)
>
> Delay : 1.525178
> Delay : 1.781971
> ..
>
> *Problem B* *******************************************
>
> After reproducing Problem A, we terminate process 2) by hitting
> Ctrl-C.
>
> Even then, channel tuning time stay high in process 1), you will still see
>
> Delay : 1.773303
> Delay : 1.781734
> Delay : 1.749948
> ..
>
> This is not good.
>
> *Problem C* *******************************************
>
> What is even worse:
>
> Very often, you will soon run into trouble: After a very iterations,
> you will see:
>
> Delay : 21.616521
> Delay : 21.773475
> Delay : 21.765678
>
> This means that tuning was not possible anymore at all.  In this
> situation, it always helps to re-load the module by runing:
>
> su -c "rmmod ngene && modprobe ngene one_adapter=0"
>
> *Problem D* *******************************************
>
> When terminating process 1) and immediately restarting it, channel
> tuning times - again - stay high. This is not good.
>
> Often you will also see Problem C then.
>
> *Problem E* *******************************************
>
> Go back to reproducing Problem A (process 1 and 2 are running), and
> the continuously start and terminate process 2) by hitting Ctrl-C
> again and again. Sooner or later, you will see Problem C occur then.
>
> *Remark* *******************************************
>
> It _seems_ that, after terminating all szap-s2 processes, and waiting 1
> to 2 minutes, and then restarting szap-s2 again, the failures/problems
> seem to be gone _without_ reloading the module.
>
> thanks for your help,
> Andreas Besse
>
>
>   

