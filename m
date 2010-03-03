Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55585 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0CCPtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 10:49:52 -0500
Received: by bwz1 with SMTP id 1so3987bwz.21
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 07:49:51 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Hendrik Skarpeid <skarp@online.no>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Wed, 3 Mar 2010 17:49:23 +0200
Cc: linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
References: <4B7D83B2.4030709@online.no> <201003030110.32834.liplianin@me.by> <4B8E1FF1.8050605@online.no>
In-Reply-To: <4B8E1FF1.8050605@online.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003031749.24261.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 марта 2010 10:38:09 Hendrik Skarpeid wrote:
> Igor M. Liplianin skrev:
> > On 2 марта 2010, "Igor M. Liplianin" <liplianin@me.by> wrote:
> >> Igor M. Liplianin skrev:
> >>> On 23 февраля 2010 15:12:05 Nameer Kazzaz wrote:
> >>>> Sounds cool, let me know if I can help you with anything.
> >>>>
> >>>> Thanks
> >>>> Nameer
> >>>>
> >>>> Hendrik Skarpeid wrote:
> >>>>> No luck here either, still working on it.
> >>>>> My plan is to solder som wires on strategic points on the board and
> >>>>> debug i2c and other activity with an oscilloscope. Will probably
> >>>>> start next week.
> >>>>>
> >>>>> Nameer Kazzaz wrote:
> >>>>>> Hey Igor,
> >>>>>> I'm getting the same error:
> >>>>>> dm1105 0000:04:0b.0: could not attach frontend
> >>>>>>
> >>>>>> Did you get your one to work.
> >>>>>>
> >>>>>> Thanks
> >>>>>> Nameer
> >>>>>>
> >>>>>> Igor M. Liplianin wrote:
> >>>>>>> On 18 февраля 2010, liplianin@me.by wrote:
> >>>>>>>> I also got the unbranded dm1105 card. I tried the four possible
> >>>>>>>> i2c addresses, just i case. Noen worked of course. Then I traced
> >>>>>>>> the i2c pins on the tuner to pins 100 and 101 on the DM1105.
> >>>>>>>> These are GPIO pins, so bit-banging i2c on these pins seems to be
> >>>>>>>> the solution.
> >>>>>>>>
> >>>>>>>> scl = p101 = gpio14
> >>>>>>>> sda = p100 = gpio13
> >>>>>>>
> >>>>>>> Here is the patch to test. Use option card=4.
> >>>>>>>     modprobe dm1105 card=4
> >>>
> >>> I didn't test patch in real hardware.
> >>> But I can connect GPIO14 and GPIO13 to SCL and SDA in any dm1105 card
> >>> and test whether it works. Then I will ask you to test also.
> >>>
> >>>
> >>> -----------------------------------------------------------------------
> >>>-
> >>>
> >>>
> >>> No virus found in this incoming message.
> >>> Checked by AVG - www.avg.com
> >>> Version: 9.0.733 / Virus Database: 271.1.1/2708 - Release Date:
> >>> 02/24/10 20:34:00
> >>
> >> Think I solved it.
> >> The dm1105_getsda and dm1105_getscl functions need to mask out the other
> >> GPIO bits.
> >> I hacked the code to return 1 if corresponding GPIO set, and 0 if not
> >> set. That did the trick. Now the frontend registers and /dev/dvb is
> >> populated. :)
> >> Haven't done any tuning yet.
> >
> > Do you cut connections between dm1105 i2c pins and the
> > gpio pins you make earlier?
>
> Success!
Glad to hear.
Now to find GPIO's for LNB power control and ... watch TV :)

>
> [ 4354.673688] dm1105 0000:03:01.0: PCI INT A -> GSI 19 (level, low) ->
> IRQ 19
> [ 4354.673806] DVB: registering new adapter (dm1105)
> [ 4354.921866] dm1105 0000:03:01.0: MAC 00:00:00:00:00:00
> [ 4355.533170] DVB: registering adapter 0 frontend 0 (SL SI21XX DVB-S)...
> [ 4355.533327] input: DVB on-card IR receiver as
> /devices/pci0000:00/0000:00:1e.0/0000:03:01.0/input/input7
> [ 4355.533377] Creating IR device irrcv0

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
