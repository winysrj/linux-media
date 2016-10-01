Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33095 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751006AbcJAJTf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2016 05:19:35 -0400
Received: by mail-lf0-f43.google.com with SMTP id t81so56069235lfe.0
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2016 02:19:34 -0700 (PDT)
Date: Sat, 1 Oct 2016 11:19:31 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: gose: add HDMI input
Message-ID: <20161001091931.GL8472@bigcity.dyn.berto.se>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
 <1951325.PMIbTHqE2x@avalon>
 <CAMuHMdV3ZSfMeyCv3j8F3rUeT48nQc-03L5iDXYF-=wT7Ek2nw@mail.gmail.com>
 <3186140.opQPlkUUe2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3186140.opQPlkUUe2@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-09-30 16:32:52 +0300, Laurent Pinchart wrote:
> On Friday 30 Sep 2016 15:00:59 Geert Uytterhoeven wrote:
> > On Fri, Sep 30, 2016 at 2:40 PM, Laurent Pinchart wrote:
> > >> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> > >> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> > >> @@ -374,6 +374,11 @@
> > >>               groups = "audio_clk_a";
> > >>               function = "audio_clk";
> > >>       };
> > >> +
> > >> +     vin0_pins: vin0 {
> > >> +             groups = "vin0_data24", "vin0_sync", "vin0_clkenb",
> > >> "vin0_clk";
> > >> +             function = "vin0";
> > >> +     };
> > >>  };
> > >>  
> > >>  &ether {
> > >> @@ -531,6 +536,21 @@
> > >>               };
> > >>       };
> > >> 
> > >> +     hdmi-in@4c {
> > >> +             compatible = "adi,adv7612";
> > >> +             reg = <0x4c>;
> > >> +             interrupt-parent = <&gpio1>;
> > >> +             interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
> > > 
> > > Isn't the interrupt signal connected to GP4_2 ?
> > 
> > No idea about Gose, but on Koelsch it is (hence koelsch DTS is wrong??)
> 
> I believe so. I don't have a Koelsch board anymore so I can't test that. 
> Niklas, do you have a Koelsch on which you could confirm the IRQ number ?

I have done the best I can to prove the IRQ, it proved to be a bit 
tricky or maybe I'm doing it the wrong way.

I hooked up my oscilloscope to EXIO Connector D pin 7, which according 
to the schematics should be GP4_2 and attached to a pull-up at 3.3v. I 
can observe the pull-up and if I control the pin using the 
/sys/class/gpio interface I do indeed control GP4_2, So the schematic is 
correct at least this far.

The trouble I have is that the adv7612 driver do not currently consume 
the interrupt so I can't see multiple field interrupts by observing the 
pin. I do however see what I believe is the first field interrupt, if I 
observe the pin just as I turn on my HDMI video source the pin go from 1 
-> 0 but is never reset and a reset of the entire board is needed if you 
wish to see it again.

If I on the other hand observe pin GP1_20 on EXIO Connector A pin 66 I 
notice nothing on the oscilloscope from that it's set to 3.3V at power 
on, no mater how much HDMI input i run.

In conclusion, yes I do believe the DTS is wrong and that GP4_2 is the 
correct interrupt signal on Koelsch. This adds up with the schematics 
and my rudimentary measurements.

-- 
Regards,
Niklas Söderlund
