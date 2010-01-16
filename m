Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39548 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0APOMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 09:12:52 -0500
Received: by bwz27 with SMTP id 27so1213561bwz.21
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 06:12:50 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: paul10@planar.id.au, "linux-media" <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Sat, 16 Jan 2010 16:12:31 +0200
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au> <fded4e7b5651846ee885157dff27bf5c@mail.velocitynet.com.au> <8d15809584306ed08401d6b06dccfcaf@mail.velocitynet.com.au>
In-Reply-To: <8d15809584306ed08401d6b06dccfcaf@mail.velocitynet.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001161612.31441.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 января 2010 15:18:07 paul10@planar.id.au wrote:
> Igor wrote:
> > Accordingly datasheet possible demod addresses are 0x68, 0x69, 0x6a,
>
> 0x6b only.
>
> > Possibly there is some DM1105 GPIO drives reset for demod.
> > I assume it is last (26, top right if you look from card elements side)
>
> pin on tuner.
>
> > You can visually trace way from can tuner. Or use multimeter.
>
> Sorry, that is a bit beyond me.
>
> If I understand correctly, I'm looking for the top right pin from the
> tuner when I'm looking at the side of the card that has all the chips on
> it.  I can see that, and there are a number of traces that run from there
> to the DM1105, and also a few that run to other components on the card.
>
> I'm assuming I need to follow the topmost of the traces that go to the
> DM1105, and see which pin on the DM1105 it goes to.
>
> My eyesight isn't that good...but I have a magnifying glass.  If I follow
> the topmost of the traces it looks to run to the rightmost pin on the top
> row of pins on the DM1105, when the writing on the DM1105 is the right way
> up.  I didn't find a data sheet for the DM1105, so I can't tell if that is
> a GPIO pin or not.
>
> The next trace down from the top right on the tuner appears to end without
> connecting.  It ends in a small brass circle, and doesn't appear to go
> through to the back of the board and connect anywhere.  The next one below
> that goes to the fifth pin in from the right hand end of the top row on the
> DM1105.
>
> Am I doing the right thing here - does this make sense?
>
> I've drawn on the photo so you can see what I'm doing.  Refer:
> http://planar.id.au/Photos/img_1964%20%28copy%29.jpg.  The far right blue
> line comes from the top most right hand pin on the tuner, runs under the
> board at the brass circle, and comes out again to join on to the rightmost
> pin.  The next blue line in is the one going to the fifth pin, it is the
> third track down coming from the tuner.  In between the two is a track that
> appears to go nowhere.  I've marked in white roughly where they are coming
> out of the tuner.
>
> Thanks again for all your help,
>
> Paul
Well, as I understood, GPIO15 drives reset for demod.
dm1105 driver needs little patching.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
