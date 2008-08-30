Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KZSP0-0000jN-AQ
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 17:30:16 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Sat, 30 Aug 2008 17:30:09 +0200
References: <48B8400A.9030409@linuxtv.org>
In-Reply-To: <48B8400A.9030409@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808301730.09135.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

On Friday 29 August 2008 20:29:30 Steven Toth wrote:
>
> Mauro Chehab, Michael Krufky, Patrick Boettcher and myself are hereby
> announcing that we no longer support multiproto and are forming a
> smaller dedicated project group which is focusing on adding next
> generation S2/ISDB-T/DVB-H/DVB-T2/DVB-SH support to the kernel
> through a different and simpler API.
>
> Basic patches and demo code for this API is currently available here.
>
> http://www.steventoth.net/linux/s2

Overall API looks good.

I have also a slightly preference for DTV/dtv as prefix but it's not 
really important. 

16 properties per ioctl are probably enough but a variable-length 
property array would be safe. I'm unsure if this justifies a more 
complicate copy from/to userspace in the ioctls.

> Importantly, this project group seeks your support.
>
> If you also feel frustrated by the multiproto situation and agree in
> principle with this new approach, and the overall direction of the
> API changes, then we welcome you and ask you to help us.
>
> Growing the list of supporting names by 100%, and allowing us to
> publish your name on the public mailing list, would show the
> non-maintainer development community that we recognize the problem
> and we're taking steps to correct the problem. We want to make
> LinuxTV a perfect platform for S2, ISDB-T and other advanced
> modulation types, without using the multiproto patches.
>
> We're not asking you for technical help, although we'd like that  :)
> , we're just asking for your encouragement to move away from
> multiproto.
>
> If you feel that you want to support our movement then please help us
> by acking this email.

Acked-by: Janne Grunau <janne-dvb@grunau.be>

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
