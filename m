Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from chokecherry.srv.cs.cmu.edu ([128.2.185.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rajesh@cs.cmu.edu>) id 1JOaWs-0007ch-JT
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 16:25:10 +0100
Received: from [192.168.1.129] (cm29.delta204.maxonline.com.sg [59.189.204.29])
	(authenticated bits=0)
	by chokecherry.srv.cs.cmu.edu (8.13.6/8.13.6) with ESMTP id
	m1BFP2R6027952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Mon, 11 Feb 2008 10:25:06 -0500 (EST)
Message-ID: <47B068D5.3060104@cs.cmu.edu>
Date: Mon, 11 Feb 2008 23:25:09 +0800
From: Rajesh Balan <rajesh@cs.cmu.edu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47AB0219.8050408@cs.cmu.edu> <47AB0337.3050208@cs.cmu.edu>
	<47ABD87B.1040602@cs.cmu.edu>
In-Reply-To: <47ABD87B.1040602@cs.cmu.edu>
Subject: [linux-dvb] HVR1300 non-MCE IR Transmitter
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I apologize if this is not directly related to v4l development. But I 
suspect people here know the answer to this question.

Does anyone know how to activate the IR transmitter (not receiver) that 
is on the non-MCE version of the HVR-1300?  The firmware states that it 
has an IR receiver and a transmitter. The receivers works flawlessly now.

I've loaded lirc_serial and tried ports 0x2f8 and 0x3f8. my debugging of 
the kernel module indicates that data is being written to the UART (in 
both cases) using the appropriate pulse function but the LED on the 
transmitter never blinks (checked with a digital cam LCD).  I've tried 
every type supported by the lirc_serial driver. no go.

I'm beginning to suspect that the transmitter does not behave as a 
serial device and that something else needs to be done. is this correct? 
if so, does anyone know what? There is precious little information about 
the transmitting portion of the hvr1300 on the web. what do people use 
to control their cable boxes?

Thanks,

Rajesh

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
