Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40440 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbeKBROy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 13:14:54 -0400
Received: by mail-wr1-f41.google.com with SMTP id i17-v6so1021336wre.7
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 01:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
 <b368e66b-eafa-1c3e-f75d-a57ccb6cc125@gmail.com>
In-Reply-To: <b368e66b-eafa-1c3e-f75d-a57ccb6cc125@gmail.com>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Fri, 2 Nov 2018 09:09:42 +0100
Message-ID: <CAL8zT=iDHfDPNWruBaLWjrUSgq6dLG34YR3bi1ini=oX_KsnLw@mail.gmail.com>
Subject: Re: i.MX6: can't capture on MIPI-CSI2 with DS90UB954
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        kieran.bingham@ideasonboard.com, jacopo mondi <jacopo@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Le mer. 31 oct. 2018 =C3=A0 22:52, Steve Longerbeam <slongerbeam@gmail.com>=
 a =C3=A9crit :
>
> Hi Jean-Michel,
>
> We've done some work with another FPD-Link de-serializer (ds90ux940) and
> IIRC we had some trouble figuring out how to coax the lanes into LP-11
> state. But on the ds90ux940 it can be done by setting bit 7 in the CSI
> Enable Port registers (offsets 0x13 and 0x14). But the "imx6-mipi-csi2:
> clock lane timeout" message is something else and indicates the
> de-serializer is not activating the clock lane during its s_stream(ON)
> subdev call.

I have been doing more work on the driver I have, and I had CSI
enabled before the csi2_dphy_wait_stopstate() call for instance. Now,
LP-11 state is ok.
Then, in the s_stream subcall, I added a delay after enabling CSI (and
the continuous clock) and it is better too, as the clock is seen
correctly each time.
But I still get into a EOF timeout, which sounds like another issue.

FYI, I added the NFACK interrupt support in my local kernel just to
see if New Frames are detected, and it is not the case either.
Any reason for not using this interrupt (maybe in "debug" mode) ?

Now, I used a scope (not very fast so I can't get into the very fast
signals) and I can see some weird things.
In a 1-lane configuration, and a 400MHz clock, I can get the following
when looking at D0N and D0P (yellow and green, can't remember which
color is which) :
https://framapic.org/H65QXHvaWmao/qdyoARz12dNi.png

The purple is the diff result.

First I thought it was a start sequence (but with very bizarre things
at the very beginning of the sequence) like described here :
https://cms.edn.com/ContentEETimes/Images/EDN/Design%20How-To/MIPI_Sync-Seq=
uence-in-the-transmitted-pattern.jpg

But Jacopo remarked that the 'starting sequence' is actually sent in
HS mode, so we should not be able to see it at all.
He thinks that what we are looking at is actually a bad LP-11 -> LP01
-> LP00 transition.

And it could be the "HS ZERO" :
https://cms.edn.com/ContentEETimes/Images/EDN/Design%20How-To/MIPI_HS-Burst=
-on-Data-Lane.jpg

What do you think of this ?
We will conduce more complex measurements, with high speed analyzers
in order to check everything, and we are right now focusing on a
possible hardware issue (coule be the custom PCB which embeds the
DS90UB954).

Thanks,
JM
