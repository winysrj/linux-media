Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robm@fastmail.fm>) id 1KIjcY-0008Cn-Sg
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 14:27:08 +0200
Message-ID: <35c901c8e676$4a2ad6b0$0a01a8c0@robmhp>
From: "Rob Mueller" <robm@fastmail.fm>
To: <linux-dvb@linuxtv.org>
Date: Tue, 15 Jul 2008 22:28:26 +1000
MIME-Version: 1.0
Cc: pboettcher@dibcom.fr, ademol@dibcom.fr
Subject: [linux-dvb] Nova-T 500 DiBcom chipset Australia (ABC,
	SBS) specific problems?
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

Hi

After reading that the Hauppauge Nova-T 500 seemed stable, I recently
upgraded from a rather old Twin MiniTer DVT DVB-T card to a Nova-T 500 to
get the dual tuner. However I'm experiencing some problems with the card.

I'm based in Melbourne, Australia where we have 5 main digital free to air
channels. 3 of them work fine (Seven, Nine, Ten), but 2 of them (ABC, SBS)
cause strange and intermittent problems.

Basically the channels ABC & SBS *sometimes* work perfectly fine, but other
times are completely choppy and broken.

Particularly strange is that you can record a program on ABC/SBS (i use
mythtv), get a completely choppy and unwatchable stream and then then record
another program _immediately_ after it with a 1 minute gap on the same
channel, and it will be fine. It's as if the card sometimes locks badly on
the signal and won't fix itself, but changing away and back to the channel
again can make it fix itself.

Now my initial reaction was that it's a signal problem, but a number of
things suggest that's not really the case.

Adding/removing a line amplifier changes the reported signal strength, but
doesn't change the problem. All other 3 channels are fine, just ABC/SBS give
intermittent problems still. Turning on/off the LNA setting also changes the
reported signal strength, but also doesn't change the problem. In mythtv
even with the LNA off the 3 normal channels work fine, just ABC/SBS have the
exact same strange and intermittent problem still.

I thought it might be a tuner delay issue, so I set the "DVB Tuning Delay
(msec)" in mythtv to 150, but that didn't help either.

Doing some more searching, I came across some interesting posts in an MCE
forum. Basically it seems the MCE users in Australia were having the exact
same problem with Nova-T 500 cards last year. All channels fine except
ABC/SBS in Melbourne and some regional areas specifically. Now a couple of
posts suggest that this was actually a DiBcom chipset driver issue:

http://www.xpmediacentre.com.au/community/tuners-mce/12244-hauppage-nova-t-500-driver-bug-19.html#post118420

---
- The problem with tuning to ABC and SBS is due to the DiBcom chipset having
problems with the Australian 7mHz bandwidth (most of the world use 8mHz).
This affects all card brands with this cipset... its just the NovaT500 is
the most popular one.
- DiBcom shipped a diagnostic device to ? (New Magic?) for testing the card.
Testing has been done all round Melbourne (and other cities?) and the data
collected sent to DiBcom.
- New Magic are currently testing an updated DiBcom firmware. It might be
released soon, maybe end of the week, if a deployment process can be
devised. Currently, the upgrade process is "convoluted".
---

If you read in the next couple of posts on that page, you'll see that users
report that an updated driver package did fix the problem for a lot of
users. And there's this post from "New Magic Australia", the Nova-T 500 card
distributor in Australia I believe.

http://www.xpmediacentre.com.au/community/tuners-mce/12244-hauppage-nova-t-500-driver-bug-20.html#post120121

---
After many months of almost daily effort we are happy to announce that we
have a release candidate update for the Nova 500 card, to fix the issues on
ABC and SBS (and other services) in some parts of Melbourne and some
regional areas. At this stage it's a release candidate but already many
users who have been given the update for testing are reporting great
results.

...

For those interested the issue actually had nothing to do with Hauppauge,
but rather was a chipset issue which we have identified in other tuner and
set-top products. Because the issue is unique to only small parts of
Australia, many users and manufacturers write the symptoms off as a
reception problem. Once a final firmware/driver update is released, anyone
interested in the technical details can contact me for more info.
---

So basically I'm wondering if this particular problem was fixed for MCE
users by an updated windows driver, but hasn't been fixed in the linux v4l
code tree. If it hasn't been fixed in the linux tree, I'm wondering what the
best way to try and debug and fix this is. It seems a rather annoying edge
case, but obviously it's caused me a lot of headaches :)

Thanks in advance

Rob

cc'd pboettcher@dibcom.fr and ademol@dibcom.fr as they're listed in the
dib*.{h,c} files as the main authors, and patrick.boettcher@desy.de from the
current firmware download page in the hope they can shed some light...


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
