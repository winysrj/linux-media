Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JoZWU-00083Q-AU
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 09:36:15 +0200
Date: Wed, 23 Apr 2008 09:35:27 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: "Rajendra C. Turakani" <rajendra.turakani@ittiam.com>
In-Reply-To: <904DEC693BE1AB429622C6F5ABA7E0B804307B76@is01ex02.ittiam.com>
Message-ID: <Pine.LNX.4.64.0804230932130.9074@pub6.ifh.de>
References: <904DEC693BE1AB429622C6F5ABA7E0B804307B76@is01ex02.ittiam.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Query on USB based DVB-T modules.
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

Hi Rajendra,

On Wed, 23 Apr 2008, Rajendra C. Turakani wrote:
> 1.       Is 'Leadtek Winfast DTV Dongle' based on as DiB3000M chipset ?
> Is the driver source code available ?

Yes. I think the device used inside this Dongle is 3000P. The driver is 
identical between the two revision.

> 2.       How can one get detailed datasheet of DiB3000M ?

Ask DiBcom support. But if you want to develop software, it is not the 
right start, because the data sheet is mainly to help people integrate the 
hardware.

When you use the driver from LinuxTV make sure that you follow the GPL 
rules when adapting it.

> 3.       What is the chipset that is used in 'Hauppauge WinTV Nova-T
> (USB)' ?

There are several devices with that name:

USB2: DiB3000P
TD: DiB7000P or DiB7070P

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
