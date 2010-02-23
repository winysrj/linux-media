Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48723 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0BWRkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 12:40:20 -0500
Received: by bwz1 with SMTP id 1so1196807bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 09:40:18 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Nameer Kazzaz <nameer.kazzaz@gmail.com>,
	Hendrik Skarpeid <skarp@online.no>, linux-media@vger.kernel.org
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Tue, 23 Feb 2010 19:40:12 +0200
References: <4B7D83B2.4030709@online.no> <4B83C6C0.5020708@online.no> <4B83D425.6060803@gmail.com>
In-Reply-To: <4B83D425.6060803@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201002231940.13385.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 февраля 2010 15:12:05 Nameer Kazzaz wrote:
> Sounds cool, let me know if I can help you with anything.
>
> Thanks
> Nameer
>
> Hendrik Skarpeid wrote:
> > No luck here either, still working on it.
> > My plan is to solder som wires on strategic points on the board and
> > debug i2c and other activity with an oscilloscope. Will probably start
> > next week.
> >
> > Nameer Kazzaz wrote:
> >> Hey Igor,
> >> I'm getting the same error:
> >> dm1105 0000:04:0b.0: could not attach frontend
> >>
> >> Did you get your one to work.
> >>
> >> Thanks
> >> Nameer
> >>
> >> Igor M. Liplianin wrote:
> >>> On 18 февраля 2010, liplianin@me.by wrote:
> >>>> I also got the unbranded dm1105 card. I tried the four possible i2c
> >>>> addresses, just i case. Noen worked of course. Then I traced the i2c
> >>>> pins on the tuner to pins 100 and 101 on the DM1105.
> >>>> These are GPIO pins, so bit-banging i2c on these pins seems to be the
> >>>> solution.
> >>>>
> >>>> scl = p101 = gpio14
> >>>> sda = p100 = gpio13
> >>>
> >>> Here is the patch to test. Use option card=4.
> >>>     modprobe dm1105 card=4
I didn't test patch in real hardware.
But I can connect GPIO14 and GPIO13 to SCL and SDA in any dm1105 card and test whether it works.
Then I will ask you to test also.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
