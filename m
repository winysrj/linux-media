Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Thomas Goerke" <tom@goeng.com.au>
To: "'Steven Toth'" <stoth@linuxtv.org>
References: <20080827061320.298E2104F0@ws1-3.us4.outblaze.com>
	<003201c9082d$4b7fff80$e27ffe80$@com.au>
	<48B55F8D.9090005@linuxtv.org>
In-Reply-To: <48B55F8D.9090005@linuxtv.org>
Date: Thu, 28 Aug 2008 08:40:21 +0800
Message-ID: <000701c908a6$aba6f9d0$02f4ed70$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org, stev391@email.com
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
> http://steventoth.net/ReverseEngineering/PCI/
> 
> This was the version I originally added cx23885/7/8 support to.
> 
> It assumes dscaler is installed.
> 
> - Steve
I have updated http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F to
include the Register dumps. Note that I was unable to get the Compro FM
Tuner Application to work correctly even after several reboots.  For some
reason the FM tuner application starts, scans through all the channels and
then hangs.  I have included the register dump for this state but cannot
guarantee that the register values are correct.  Analog and Digital TV work
fine.

Let me know if you need anything else.

Thanks

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
