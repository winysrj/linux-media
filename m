Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ralf.netmindz.net ([217.147.82.19])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <will@netmindz.org.uk>) id 1JOrWO-0005HS-S1
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 10:33:48 +0100
Message-ID: <47B167FB.9070607@netmindz.org.uk>
Date: Tue, 12 Feb 2008 09:33:47 +0000
From: Will Tatam <will@netmindz.org.uk>
MIME-Version: 1.0
To: Craig Whitmore <lennon@orcon.net.nz>
References: <C36C2AD2C1B74AA98CA40F6A1C0644EF@CraigPC>
In-Reply-To: <C36C2AD2C1B74AA98CA40F6A1C0644EF@CraigPC>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Multi Frontend Drivers for HVR4000 (And others)
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

Craig Whitmore wrote:
> You have to do the below so it sees two cards
>  
> mkdir /dev/dvb/adapter1
> ln -s /dev/dvb/adapter1/frontend1 /dev/dvb/adapter1/frontend0
> ln -s /dev/dvb/adapter1/net1 /dev/dvb/adapter1/net0
> ln -s /dev/dvb/adapter1/dvr1 /dev/dvb/adapter1/dvr0
> ln -s /dev/dvb/adapter1/demux1 /dev/dvb/adapter1/demux0
>  

I guess you mean

mkdir /dev/dvb/adapter1
ln -s /dev/dvb/adapter0/frontend1 /dev/dvb/adapter1/frontend0
ln -s /dev/dvb/adapter0/net1 /dev/dvb/adapter1/net0
ln -s /dev/dvb/adapter0/dvr1 /dev/dvb/adapter1/dvr0
ln -s /dev/dvb/adapter0/demux1 /dev/dvb/adapter1/demux0

where adapter0 is your real card and adapter1 is one higher than your
existing adapter number (e.g 0 in this case)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
