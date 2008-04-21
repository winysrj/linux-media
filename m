Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web55605.mail.re4.yahoo.com ([206.190.58.229])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <trevor_boon@yahoo.com>) id 1Jnp06-0002Y3-V2
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 07:55:39 +0200
Date: Mon, 21 Apr 2008 15:54:54 +1000 (EST)
From: Trevor Boon <trevor_boon@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <919241.88594.qm@web55605.mail.re4.yahoo.com>
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
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

Hi Amitay,

Although, this is just speculation, the pcb label is
lr6655 which, afaik, is a Lifeview model code?

I've had a look at the driver inf file (lr6655.inf)
and can only see three files being used:

3xHybrid.sys
NXPMV32.dll
(34CoInstaller.dll) is remarked out in the lr6655.inf

I can also see 'Proteus' reference board being listed
in the driver .inf file. Does this help?



      Get the name you always wanted with the new y7mail email address.
www.yahoo7.com.au/y7mail



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
