Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KXymF-0003vz-Om
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 15:40:10 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com
References: <20080826065046.C51B732675A@ws1-8.us4.outblaze.com>
In-Reply-To: <20080826065046.C51B732675A@ws1-8.us4.outblaze.com>
Date: Tue, 26 Aug 2008 21:40:40 +0800
Message-ID: <001f01c90781$56c27550$04475ff0$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
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

> From: stev391@email.com [mailto:stev391@email.com]
---snip---
> Thomas,
> 
> I'm happy to give it a go...
> 
> The Zarlink demod is the exact same chip as the Intel one mentioned
> previously.  Zarlink sold there demodulator (and possibly others) to
> Intel.  The driver in Linux is still known as the Zarlink 10353, this
> is not going to be a problem.
> 
> The same windows driver controls both of these cards (and the E300,
> E500 both normal and F versions), so they should be pretty similar
> (except got for the HW mpeg encoder, and the power on support). (The
> driver is based on the reference design as well)
> 
> Create a wiki page for this card with the same information I need for
> the E650, hopefully when I get the DVB-T going in one it will be a
> simple matter for the other.
> 
> I don't want to get your hopes up with the analog side yet, as I have
> not managed to quite work out what I need to do there.
> 
> Thanks for the email
> 
> Regards,
> 
> Stephen
> 
> P.S. Please do not top post, reply to the email at the bottom. This
> will help people who are catching up with this thread...
> 
> 
> --
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com
Stephen,

I have created the page as requested:
http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F. 

I was able to run the regspy as requested but it was unclear to me how I was
supposed to provide you with registry outputs.  Using the save command only
seemed to provide vb or java script which didn't include anything specific
as to registry contents.  If you can let me know the specific registry entry
you are interested in (or a rough description) I can reboot under XP and
find these values for you.

Thanks in advance

Tom



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
