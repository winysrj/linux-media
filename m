Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59205 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab1AHPUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:35 -0500
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Andy Walls <awalls@md.metrocast.net>
To: Lawrence Rust <lawrence@softsystem.co.uk>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1294488550.9475.20.camel@gagarin>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <1294488550.9475.20.camel@gagarin>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Jan 2011 09:22:08 -0500
Message-ID: <1294496528.2443.85.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-08 at 13:09 +0100, Lawrence Rust wrote:
> On Mon, 2011-01-03 at 17:34 -0500, Andy Walls wrote:
> > On Sun, 2011-01-02 at 23:00 -0500, Eric Sharkey wrote:
> > > On Fri, Dec 31, 2010 at 7:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > > > Mauro,
> > > >
> > > > Please revert at least the wm8775.c portion of commit
> > > > fcb9757333df37cf4a7feccef7ef6f5300643864:
> > > >
> > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fcb9757333df37cf4a7feccef7ef6f5300643864
> > > >
> > > > It completely trashes baseband line-in audio for PVR-150 cards, and
> > > > likely does the same for any other ivtv card that has a WM8775 chip.
> > > 
> > > Confirmed.  I manually rolled back most of the changes in that commit
> > > for wm8775.c, leaving all other files alone, and the audio is now
> > > working correctly for me.  I haven't yet narrowed it down to exactly
> > > which changes in that file cause the problem.  I'll try and do that
> > > tomorrow if I have time.
> 
> Oh dear, you leave the ranch for 5 minutes to a place without email and
> all hell breaks loose.  Didn't anyone think that New Year is a time for
> holidays?
> 
> So, for a minor niggle, which is trivially sorted, you pull almost the
> whole patch leaving the only bit that causes problems for the Nova-S
> (for which the patch was intended).

Sorry Lawrence.  I didn't have time to review and test the original
patch properly when you submitted it.  By the time the regression was
discovered there was not time for me to fix.  (I did have to do work for
customers between Christmas and New Year's :( ).

Getting fixes back into stable trees is a royal PITA and has a time lag
waiting for the fix to get upstream first.  It's better not to let
regression slip forward into a kernel release.

If the PVR-150 was some low volume distribution card that no one used or
had only been in the kernel for only a few releases, I wouldn't have
pushed so hard for the revert.

However the PVR-150 is a very popular card and many units are in service
with linux users.  It is the 1st choice for analog recording for many
users with a MythTV setup.  With the transition to DTV in the US, the
PVR-150's banseband input is the most useful part of the card in the US.

>   The remnant,
> drivers/media/video/cx88/cx88-cards.c line 970, adds wm8775 baseband
> audio-in which is horribly distorted without the patch.  So I suggest it
> too is removed.
> 
> Now, if someone can direct me to a full hardware description for the
> PVR-150 

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/ivtv/ivtv-cards.c;h=87afbbee20636f1e9f1192f8592a35954382bd7f;hb=master#l190
http://www.hauppauge.com/site/support/support_pvr150.html


> and datasheets for the components connected to the wm8775 then
> I'll endeavour to provide a solution compatible with both.

WM8775:
http://dl.ivtvdriver.org/datasheets/audio/WM8775.pdf

CX2584[0123]:
http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf

CX23416 (old, but the first hit with a Google search):
http://www.google.com/url?sa=t&source=web&cd=1&sqi=2&ved=0CBQQFjAA&url=http%3A%2F%2Fwww.icbank.com%2Ficbank_data%2Fonline_seminar%2Fconexant_060517%2FDatasheet.pdf&rct=j&q=CX23416%20datasheet&ei=GHAoTf31MYWglAeh_bG4AQ&usg=AFQjCNHESSp00ahlEGzxm6I-RXZ7WBMA0w&cad=rja

One of many different analog tuners that can bue used with a PVR-150:
http://dl.ivtvdriver.org/datasheets/tuners/TAPE-H091F_MK3.pdf

Good photographs of the PVR-150MCE board:
http://www.ixbt.com/monitor/images/hauppauge-pvr150/hauppauge-pvr-150-front.jpg
http://www.ixbt.com/monitor/images/hauppauge-pvr150/hauppauge-pvr-150-back.jpg

Approximate layout of the sound path:

+-------------+                        +---------------+
|          SIF|----------------------->|AFE In8        |    +---------+
|   Analog    |                        |    CX25843    |    | CX23416 |
|   Tuner     |       +-----------+    |               |    |         |
|        TV AF|------>|AIN1    I2S|--->|I2S In  I2S Out|--->|I2S In   |
|       FM L,R|------>|AIN4       |    +---------------+    |         |
+-------------+       |   WM8775  |                         |      PCI|<--->
                      |           |                         +---------+
Line In 1 L,R ------->|AIN2       |
Line In 2 L,R ------->|AIN3       |
                      +-----------+



Note that
1. the PVR-500 is essentially two PVR-150's on on card and also uses the
WM8775/CX2584x combination but with smaller, probably poorer performing,
ananlog tuners. .
2. other cards use the CX2584x with something other than a WM8775 (e.g.
a WM8739 with a 74HC4052 analog mux chip)
3. the ivtv driver support use of the CX23416 with other audio decoder
chips aside from the CX2584x family, such as MSP34xx or SAA717x chips.
4. the pvrusb2 module is approximately a USB connected version of a
PVR-150.

Perturbing the hardware configuration code in the ivtv, cx25840, wm8775
modules has to be done with some care.  Otherwise, hardware that has
been deployed and in use under linux for a while will break.

Linus is pretty clear on his policy about breaking userspace:

https://lkml.org/lkml/2010/11/19/673



>   If anyone
> can loan me a PVR-150 then so much the better, but it's not essential if
> the full docs are available.

It would be cheaper for me to buy it for you than to ship you one from
the US:

http://shop.ebay.co.uk/?_from=R40&_trksid=p4295.m570.l1313&_nkw=PVR-150&_sacat=See-All-Categories

They are a lot of these units out there. Used ones are *really* cheap.

Regards,
Andy


