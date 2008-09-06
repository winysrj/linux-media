Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1Kbppp-0004U2-4w
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 06:55:46 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080905221347.5F8101BF28D@ws1-10.us4.outblaze.com>
In-Reply-To: <20080905221347.5F8101BF28D@ws1-10.us4.outblaze.com>
Date: Sat, 6 Sep 2008 12:56:15 +0800
Message-ID: <00d901c90fdc$e6f1ae30$b4d50a90$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
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

> 
> Tom,
> 
> So the V0.2 patch worked after a cold reboot (No power to the computer
> then starting up again). Is that what you are saying?
> (Make sure that the v0.1 modules are not loaded on boot up if you are
> testing V0.2)
> 
> I was expecting the DMA timeout errors when using V0.2 from a cold
> start, it should not have caused it to break for a warm start (i.e.
> V0.1 modules loaded, then removed and v0.2 modules loaded).
> 
> Sorry to ask for clarification, as the results were not what I was
> expecting.
> 
> Can you try the:
> modprobe cx23885 i2c_scan=1
> That Steve Suggested.
> 
> Thanks
> 
> Stephen
Stephen,

V0.1
	Cold Reset (0ff for 10 second):	No errors from dmesg
							Can tune and watch
channels
	Warm Reset (ie sudo reboot):		Many errors in dmesg
							Can tune and watch
channels
V0.2
	Cold Reset (0ff for 10 second):	No errors from dmesg
							Can tune and watch
channels
	Warm Reset (ie sudo reboot):		Many errors in dmesg
							Tuning fails.
Unable to watch channels

Wrt sudo modprobe cx23885 i2c_scan=1, where are you expecting the output?
Given that the module is already loaded do I need to modify the
modprobe.d/cx23885 file to include the option and then reboot?

With regard to ensuring V0.1 modules are not loaded when using V0.2, the
method I have used is to have two completely different v4l_dvb source
directories and doing a make, sudo make install to use the different
versions.  I have assumed that this will copy the modules over the top of
the old modules.  Please let me know if this is not correct.

If you want me to reboot with new option let me know.

Thanks

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
