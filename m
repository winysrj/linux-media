Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail9.dslextreme.com ([66.51.199.94])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <daniel@gimpelevich.san-francisco.ca.us>)
	id 1KF3gP-0000xg-TC
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 11:03:54 +0200
Message-ID: <486F367C.1000203@gimpelevich.san-francisco.ca.us>
Date: Sat, 05 Jul 2008 01:53:16 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: Adam <sph3r3@internode.on.net>
References: <4865b170.2e5.6a9b.26067@internode.on.net>
	<486966E8.3050509@internode.on.net>
	<486A57A2.8060904@gimpelevich.san-francisco.ca.us>
	<486D5300.5010901@internode.on.net>
In-Reply-To: <486D5300.5010901@internode.on.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO FusionHDTV DVB-T Pro
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

Adam wrote:
> Daniel,
> 
> I've updated to head, applied the patch and replaced the card 
> definition.  The behaviour of failing to tune is still the same.  dmesg 
> still says "cx88[0]: Error: Calling callback for tuner 4".

Yes, it seems Chris Pascoe's tree was only partially merged after all. 
I'll try to come up with a patch that reintroduces the rest of his code 
during the coming week, but it'll involve a fair amount of guesswork. 
since I don't have the actual hardware.

> Trying to use vlc to view analog TV, composite or svideo resulted in 
> messages similar to the following in dmesg:

Hmm, that's not encouraging...

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
