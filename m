Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JY6qH-00067K-9K
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 22:44:34 +0100
Message-ID: <47D308EB.30408@philpem.me.uk>
Date: Sat, 08 Mar 2008 21:45:15 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: David Matthews <dm@prolingua.co.uk>
References: <47D0EA5B.8040105@philpem.me.uk> <47D14C71.5040400@prolingua.co.uk>
In-Reply-To: <47D14C71.5040400@prolingua.co.uk>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Updated scan file for uk-EmleyMoor
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

David Matthews wrote:
> Have you looked at the Ofcom site?  You may find that the current 
> frequencies are actually correct.  Apparently all the transmitters at 
> Emley Moor have a 166kHz offset, either + or - depending on the channel.

I've been made aware of the updated version in Hg... The version that got into 
Fedora 8 is utterly hopelessly wrong though. Frequency offsets are 'sort of' 
right, but the modulation mode and FEC settings are out in the woods for a few 
muxes.

> www.ukfree.tv seems to ignore the offset and just include the base 
> channel number.  Generally it doesn't matter since the bandwidth of the 
> tuner will be more than sufficient.  Of course, it would be a good idea 
> to fix the QAM parameters if they're wrong.

What I found odd was that my Freecom USB stick wouldn't lock to the frequency 
if the offset had been added/subtracted already. The Hauppauge Nova-TD stick's 
first tuner (MMCX? connector -- the little ~3mm thing) doesn't mind, but the 
second tuner starts losing muxes if the frequency is strong.

What's odd is the first tuner sees more on Linux than it does on Windows, and 
both tuners see different things, and on Windows both tuners see the same, but 
don't pick up Film4 (698MHz, C49, Mux D). I find this odd because by all 
rights Mux A (650MHz, C43) should be disappearing as it's the weakest... this 
would seem to rule out signal strength issues. In fact, wiring up a masthead 
amplifier just made scandvb spit out "WARNING: filter pid timeout" without 
finding any channels.

Most peculiar.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
