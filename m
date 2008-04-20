Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx.zycomm.uk.net ([80.247.17.101] helo=foxbat.zycomm.uk.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cpwp@w3z.co.uk>) id 1JnXVU-0001oi-K6
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 13:14:53 +0200
From: Charles Price <cpwp@w3z.co.uk>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Apr 2008 12:14:47 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804201214.48003.cpwp@w3z.co.uk>
Subject: [linux-dvb] Nova-HD-S2
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

Hi,

I'm attempting to get my Hauppauge Nova-HD-S2 working on my Linux machine.

When I follow the installation instructions for the HVR4000 (no multifrontend, 
no multiproto)I encounter the following error message when the system tries 
to load the videodev module:

WARNING: Error inserting v4l1_compat 
(/lib/modules/2.6.25-gentoo/kernel/drivers/media/video/v4l1-compat.ko): 
Invalid argument
FATAL: Error inserting videodev 
(/lib/modules/2.6.25-gentoo/kernel/drivers/media/video/videodev.ko): Invalid 
module format

The commands I used to build the modules are:

hg clone -r 127f67dea087 http://linuxtv.org/hg/v4l-dvb
wget http://dev.kewl.org/hauppauge/v4l-dvb-hg-sfe-latest.diff
patch -d v4l-dvb -p1 < v4l-dvb-hg-sfe-latest.diff
cd v4l-dvb && make && make install && reboot

My system is x86, with 2.6.25-gentoo kernel, gcc-4.2.3 and glibc-2.7-r1 
although I've also tried kernel 2.6.24-gentoo-r2.

Any suggestions as to what I might try next? A vanilla kernel maybe?

Thanks,

Charlie

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
