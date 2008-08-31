Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 31 Aug 2008 16:58:11 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
In-reply-to: <48B8400A.9030409@linuxtv.org>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48BAB183.8030609@hoogenraad.net>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org>
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

Dear people.

Let me introduce my position. I've bought an unsupported board.
The hardware developer gave me some code, derived from the Windows
driver. I'm trying to tidy up the code sufficiently for inclusion.

What bothers me about this discussion, is that NO technical facts pro or
contra are exchanged, and that it seems like a personal and/or progress
issue.
Looking at:
http://linuxtv.org/docs.php
I find that neither party includes an update on the Documentation tree
http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/dvb/
This means that actually trying to find out the pros and cons of what is
proposed must be derived from reading all the code and/or walking
through some years' worth of mail group contents.

So my questions are:
1) Why are the latex sources of the API documentation still maintained
in CVS ?
http://linuxtv.org/cgi-bin/viewcvs.cgi/DVB/doc/
2) Are both solutions bit-for-bit compatible with the interfaces as
published on :
http://linuxtv.org/downloads/linux-dvb-api-1.0.0.pdf
3) If so: what is the problem ? Both conform to the standard.
4) If not so: please provide updated documentation for both solutions,
so that we can make a trade-off based on high-level descriptions and
consistency rather than based on lots of code of either side.

So far, my reaction (for what it's worth) is a NACK.

Steven Toth wrote:
> Regarding the multiproto situation:
> 
....
> we're just asking for your encouragement to move away from multiproto.
> 
> If you feel that you want to support our movement then please help us by
> acking this email.
> 
> Regards - Steve, Mike, Patrick and Mauro.
> 



-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
