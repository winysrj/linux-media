Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [125.16.143.82] (helo=is01ms02.ittiam.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rajendra.turakani@ittiam.com>) id 1Joaoo-0006uT-Is
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 10:59:11 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 23 Apr 2008 14:28:29 +0530
Message-ID: <904DEC693BE1AB429622C6F5ABA7E0B804307C1F@is01ex02.ittiam.com>
In-Reply-To: <Pine.LNX.4.64.0804230932130.9074@pub6.ifh.de>
References: <904DEC693BE1AB429622C6F5ABA7E0B804307B76@is01ex02.ittiam.com>
	<Pine.LNX.4.64.0804230932130.9074@pub6.ifh.de>
From: "Rajendra C. Turakani" <rajendra.turakani@ittiam.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
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

Hi Patrick,

Thanks for the answers...

I had a few more things to ask. I noticed that the new chipset from
DiBCOM is DiB7770.

a. Are there any USB dongles (DVB-T) with DiB7770 chipset ? I am not
sure if the latest from Pinnacle (Pinnacle PCTV nano stick) has DiB7770.
b. How do we add support to these devices in the kernel ?

Question on DMB ..

1. Is there no support for DMB based USB dongles ?

Looking forward for your answers..

Regards,
Turakani

-----Original Message-----
From: Patrick Boettcher [mailto:patrick.boettcher@desy.de] 
Sent: Wednesday, April 23, 2008 1:05 PM
To: Rajendra C. Turakani
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Query on USB based DVB-T modules.

Hi Rajendra,

On Wed, 23 Apr 2008, Rajendra C. Turakani wrote:
> 1.       Is 'Leadtek Winfast DTV Dongle' based on as DiB3000M chipset
?
> Is the driver source code available ?

Yes. I think the device used inside this Dongle is 3000P. The driver is 
identical between the two revision.

> 2.       How can one get detailed datasheet of DiB3000M ?

Ask DiBcom support. But if you want to develop software, it is not the 
right start, because the data sheet is mainly to help people integrate
the 
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

**********************************************************************
This email and any files transmitted with it are confidential and
intended solely for the use of the individual or entity to whom they
are addressed. If you have received this email in error please notify
helpdesk@ittiam.com.
**********************************************************************


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
