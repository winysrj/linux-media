Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1JirVA-0005yB-Sm
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 15:35:13 +0200
Message-ID: <47FA22ED.6060308@gmx.net>
Date: Mon, 07 Apr 2008 15:34:37 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47F92310.4040500@gmx.net>
In-Reply-To: <47F92310.4040500@gmx.net>
Subject: Re: [linux-dvb] Technotrend common interfaces think my CAM is
	invalid
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

On 04/06/2008 09:22 PM, P. van Gaans wrote:
> A while ago I compiled and installed a new v4l-dvb. After that, my 
> common interface never worked correctly again. Not long after installing 
> the v4l-dvb, the PSU in my computer broke down, most likely coincidence. 
> After replacing the PSU the computer worked again. I've got both a TT 
> S-1500 and T-1500 with CI.
> 
> But the common interface still fails. So I:
> 
> *Installed the newest v4l-dvb today
> *Tried 2 other CI cables
> *Tried swapping the CI daughterboards (one 1.0a and one 1.1)
> *Tried another computer with different mainboard and (much) older 
> v4l-dvb (Ubuntu 6.10)
> *Blew the dust off my TT S2-3200 (never used before), connected the CI 
> to it and installed multiproto few weeks ago
> *Decided my old PSU must have blasted both CI daughterboards, ordered 
> new ones and installed that with v4l-dvb downloaded today
> *Re-installed the linuximage package (Ubuntu 7.10) (but not sure if all 
> v4l-dvb from hg is removed with that)
> 
> Maybe I've tried more but I don't remember right now. Anyway, nothing of 
> this helped. My official CanalDigitaal/TV Vlaanderen Mediaguard module 
> and Xcam give me "dvb_ca adapter 0: Invalid PC card inserted :(". Only 
> my Matrix Reborn initializes, but does not work correctly (corruption 
> and/or decodes only audio PID and not video and/or just acts weird). 
> Offical Conax 4.00e is not working so well anymore either (does not 
> always initialize correctly), but atm I've got no subscription card to test.
> 
> In a standalone Vantage receiver, all modules work well. So they can't 
> be invalid. I just watched Mythbusters with the offical Mediaguard 
> module. And they used to work on the TT, I only remember from the past 
> that the offical Mediaguard gave some corruption (it's compatiblity is 
> not great) but it did run. According to some linuxtv wiki this CAM 
> should now work fine.
> 
> I'll go look for some Knoppix and see if my CAMs initialize correctly 
> with that. This is really strange. If anyone's got a clue..
> 
> P.
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

Knoppix didn't want to start (couldn't read the CD, not sure why, maybe 
too old), but I found a Ubuntu 7.04 live/install CD. Started with that, 
no difference. I did find something else: I've got three different 
lenghts CI cables. One approx. 60cm, a few others approx. 40cm and some 
approx. 4cm. With 60cm, both the offical Mediaguard CAM and Xcam won't 
initialize. With 40cm, the Xcam still won't and the Mediaguard will init 
about 50% of the time. With 4cm, both Xcam and Mediaguard will always 
init. But it still doesn't work properly, even with the 4cm cable I 
couldn't get a picture with the Mediaguard, and I had a picture for 
about half a minute with the Xcam after which Kaffeine would freeze.

I'm not sure if it's a driver problem, all I know is that this started 
right after installing a new v4l-dvb a few weeks ago. The problem seems 
to have no cause:

Not the DVB-card, as the S2-3200 had the same problem.
Not the CI cable, tried many different cables and I don't believe they 
are all broken the same way.
Not the CI-daughterboard, I even bought new ones with no result.
Not the current v4l-dvb loaded, because a Ubuntu 7.04 live CD (kernel 
2.6.20 iirc) has the same result now.
Not the computer, because the setup didn't work in another computer either.
Not the CAM, all CAMs work fine in a Vantage standalone.

And note I have used this setup, S-1500+CI+long cable+Xcam for months 
without any problems.

I'm baffled.

P.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
