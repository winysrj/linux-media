Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xsmtp0.ethz.ch ([82.130.70.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cluck@student.ethz.ch>) id 1K7Y9o-0005Fi-R3
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 17:59:13 +0200
Message-ID: <4853EAC7.9080902@ethz.ch>
Date: Sat, 14 Jun 2008 17:59:03 +0200
From: Claudio Luck <cluck@ethz.ch>
MIME-Version: 1.0
To: Andrea <mariofutire@googlemail.com>
References: <g2unka$ivi$1@ger.gmane.org> <4853B5CD.3050906@ethz.ch>
	<4853BA32.4050606@googlemail.com>
In-Reply-To: <4853BA32.4050606@googlemail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use a DVB FRONTEND in read only?
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

Andrea wrote:
>> Check for open filehandles on demux device:
>  ...
> I will try that, but it sounds to me a very non natural solution.

Everything is a file :)

> Should the dvb framework tell the clients if it is streaming or not? via
> an ioctl like FE_GET_INFO?

IMHO if we realize that any streaming happens through open file handles,
we also realize that there is no need for a custom query in Linux DVB
API for the same information (circumventing or reinventing user access
control). Query the Kernel about process information.

FE_GET_INFO is specific to the frontend, not the demux.


A design question might be raised through: should readonly demux file
handles stop streaming after the readwrite demux filehandle is closed?
This behavior is different compared to frontends remaining tuned even
after closing the controlling frontend file handles.

-- 
Best Regards
Claudio

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
