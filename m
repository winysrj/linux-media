Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1Jobdk-0002qf-6L
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 11:51:54 +0200
Date: Wed, 23 Apr 2008 11:51:04 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: "Rajendra C. Turakani" <rajendra.turakani@ittiam.com>
In-Reply-To: <904DEC693BE1AB429622C6F5ABA7E0B804307C1F@is01ex02.ittiam.com>
Message-ID: <Pine.LNX.4.64.0804231145010.9074@pub6.ifh.de>
References: <904DEC693BE1AB429622C6F5ABA7E0B804307B76@is01ex02.ittiam.com>
	<Pine.LNX.4.64.0804230932130.9074@pub6.ifh.de>
	<904DEC693BE1AB429622C6F5ABA7E0B804307C1F@is01ex02.ittiam.com>
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

Hi,

On Wed, 23 Apr 2008, Rajendra C. Turakani wrote:
> a. Are there any USB dongles (DVB-T) with DiB7770 chipset ? I am not
> sure if the latest from Pinnacle (Pinnacle PCTV nano stick) has DiB7770.

Did you check the Wiki? I think there are a lot of devices mentioned. The 
LinuxTV driver however supports this device DiB7770.

> Question on DMB ..
>
> 1. Is there no support for DMB based USB dongles ?

There is a DAB USB driver. But I don't know how it works and whether it 
can be used to receive DMB (forward the MPEG2-TS to the user uncorrected).

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
