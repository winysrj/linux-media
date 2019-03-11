Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51881C4360F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2802171F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfCKObz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:31:55 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55447 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfCKObz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:31:55 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id CD97720009;
        Mon, 11 Mar 2019 14:31:51 +0000 (UTC)
Date:   Mon, 11 Mar 2019 15:32:26 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
Message-ID: <20190311143226.wreigi3nmamt2egf@uno.localdomain>
References: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
 <20190306191521.GE4791@pendragon.ideasonboard.com>
 <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
 <20190308112938.GE4802@pendragon.ideasonboard.com>
 <20190308131221.g5ueabsbhbog7oxn@uno.localdomain>
 <7edc4c80-541b-473a-f520-a758d73ce8d3@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hr3uzs2vfclwp35n"
Content-Disposition: inline
In-Reply-To: <7edc4c80-541b-473a-f520-a758d73ce8d3@xs4all.nl>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--hr3uzs2vfclwp35n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hans,

On Mon, Mar 11, 2019 at 03:05:24PM +0100, Hans Verkuil wrote:
> On 3/8/19 2:12 PM, Jacopo Mondi wrote:
> > Hi Laurent,
> >
> > On Fri, Mar 08, 2019 at 01:29:38PM +0200, Laurent Pinchart wrote:
> >> Hi Jacopo,
> >>
> >> On Thu, Mar 07, 2019 at 11:35:11AM +0100, Jacopo Mondi wrote:
> >>> On Wed, Mar 06, 2019 at 09:15:21PM +0200, Laurent Pinchart wrote:
> >>>> On Wed, Mar 06, 2019 at 12:26:59PM +0100, Jacopo Mondi wrote:
> >>>>> When both the media links between AFE and HDMI and the two TX CSI-2 outputs
> >>>>> gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
> >>>>> TXA and TXB output to get disabled.
> >>>>>
> >>>>> This causes some HDMI transmitters to stop working after both AFE and
> >>>>> HDMI links are disabled.
> >>>>
> >>>> Could you elaborate on why this would be the case ? By HDMI transmitter,
> >>>> I assume you mean the device connected to the HDMI input of the ADV748x.
> >>>> Why makes it fail (and how ?) when the TXA and TXB are both disabled ?
> >>>
> >>> I know, it's weird, the HDMI transmitter is connected to the HDMI
> >>> input of adv748x and should not be bothered by CSI-2 outputs
> >>> enablement/disablement.
> >>>
> >>> BUT, when I developed the initial adv748x AFE->TXA patches I was
> >>> testing HDMI capture using a laptop, and things were smooth.
> >>>
> >>> I recently started using a chrome cast device I found in some drawer
> >>> to test HDMI, as with it I don't need to go through xrandr as I had to
> >>> do when using a laptop for testing, but it seems the two behaves differently.
> >>>
> >>> Failures are of different types: from detecting a non-realisting
> >>> resolution from the HDMI subdevice, and then messing up the pipeline
> >>> configuration, to capture operations apparently completing properly
> >>> but resulting in mangled images.
> >>>
> >>> Do not deactivate the CSI-2 ouputs seems to fix the issue for the
> >>> Chromecast, and still work when capturing from laptop. There might be
> >>> something I am missing about HDMI maybe, but the patch not just fixes
> >>> the issue for me, but it might make sense on its own as disabling the
> >>> TXes might trigger some internal power saving state, or simply mess up
> >>> the HDMI link.
> >>
> >> I think this needs more investigation. It feels to me that you're
> >> working around an issue by chance, and it will come back to bite us
> >> later :-(
> >>
> >
> > I'm sorry I really can't tell what's happening, and why it is
> > happening on that specific device, which I cannot debug for sure.
> >
> > Ian suggested a possible cause, but I cannot tell due to my
> > HDMI-ignorance.
>
> I agree with Ian that it is likely related to EDID and/or HPD handling
> of the adv748x. The only other option is if the HDMI transmitter supports
> RxSense (i.e. detecting the pull-ups of the TMDS clock lines as a way of
> detecting that the transmitter is connected to a display).
>
> Not many transmitters support RxSense, though.
>
> HPD and/or EDID are the most likely culprits. It certainly has nothing
> to do with the CSI ports as such.

Thanks for adding more details to the issue.

Even if not related to the CSI ports directly, the issue triggers when
all of the two TXes gets disabled, and this patch prevents that from
happening. I cannot elaborate a detailed explanation of the reasons
why, so I understand if you prefer to ditch this patch. In my opinion
is better to have something that fix the issue and makes the adv748x
work with a broader number of transmitters than not, but I let you and
Laurent decide if to take this one in.

Thanks
   j

>
> Regards,
>
> 	Hans
>
> >
> >>> As disabling both TXes usually happens at media link reset time, just
> >>> before enabling one of them (or both), going through a full disable
> >>> makes little sense, even more if it triggers any sort of malfunctioning.
> >>>
> >>> Does this make sense to you?
> >>
> >> It also doesn't make too much sense to keep them both enabled when they
> >> don't need to be :-) You'll end up consuming more power.
> >>
> >
> > They've alwyas been up before introduction of dynamic routing, provided
> > something is connected to the TX source pad in DT.
> > https://elixir.bootlin.com/linux/latest/source/drivers/media/i2c/adv748x/adv748x-core.c#L489
> >
> > Power saving wise, we're not doing worse than before, and if that's a
> > concern, it should be identified first why the CSI-2 Tx PLL never gets
> > turned off:
> > https://elixir.bootlin.com/linux/latest/source/drivers/media/i2c/adv748x/adv748x-core.c#L269
> > See "mipi_pll_en, CSI-TXA Map, Address 0xDA[0]" registrer description.
> >
> > The two issues might be actually connected, I tried fixing this in the past,
> > but frame capture broke, and I didn't have time to investigate
> > fruther.
> >
> > To sum up, this patch solves an issue on some devices, it does not
> > perform worse than what we had from a power consumption perspective,
> > but I agree it might work around some deeper issues it might be worth
> > chasing.
> >
> > If I got your NAK on this, I'll keep carrying it in my tree when
> > testing with that device.
> >
> > Thanks
> >   j
> >
> >
> >>>>> Fix this by preventing writing 0 to
> >>>>> ADV748X_IO_10 register, which gets only updated when links are enabled
> >>>>> again.
> >>>>>
> >>>>> Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
> >>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>>>> ---
> >>>>> The issue presents itself only on some HDMI transmitters, and went unnoticed
> >>>>> during the development of:
> >>>>> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> >>>>>
> >>>>> Patch intended to be applied on top of latest media-master, where the
> >>>>> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> >>>>> series is applied.
> >>>>>
> >>>>> The patch reports a "Fixes" tag, but should actually be merged with the above
> >>>>> mentioned series.
> >>>>>
> >>>>> ---
> >>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
> >>>>>  1 file changed, 3 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> >>>>> index f57cd77a32fa..0e5a75eb6d75 100644
> >>>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> >>>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> >>>>> @@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,
> >>>>>
> >>>>>  	tx->src = enable ? rsd : NULL;
> >>>>>
> >>>>> +	if (!enable)
> >>>>> +		return 0;
> >>>>> +
> >>>>>  	if (state->afe.tx) {
> >>>>>  		/* AFE Requires TXA enabled, even when output to TXB */
> >>>>>  		io10 |= ADV748X_IO_10_CSI4_EN;
> >>
> >> --
> >> Regards,
> >>
> >> Laurent Pinchart
>

--hr3uzs2vfclwp35n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyGcXoACgkQcjQGjxah
VjwwGQ/+LgcJg4nwKeTdEXsf5cYa8G+Z+kB6in9SavfndKViCyemH7dpgUEm96rG
LBWQgNSVEvbQD7La6VF0/JyAJ3EgttDUDGf4M2ZKGucaWbrrBzbvxOFi9K/iC/Jl
iQWJjgWFJ7Cg8DQ0ExrsdPLAgf3uxM+dWpXPGNdtqL5IwrILiXMRFoMnlxVSRW/n
gSJS0VsglAFUj6vXNHQk4kUuyhmgA42iOg/gt3bxQeMNodWPEeAbDvjPpF112u/U
LNXqLgsUCozGoE9ZTdAcfxbLJDGXEt1IWJQnFnnW9ci3ogVnQMXPeJDYzkeqIuqV
PJ4VT6OE0pR5BhaEvwSFzxjiomhrVw9xoV+a/VQPsoxobLVIWm01sC7z8Gflh10o
guQd7q0UeasI2Ut5LdUx38k28QN8EKAgK+1SUnaI2evntI/jdn2HJHN4ZoMT1zt5
ji0U0hHQSZfUn19vEMksT3dCI9exBvI/oZNXoTHTF8Z6VxDk/R1IJ/MEzkWjeNbd
IBAnFAQUY0rDWgjEvn1G7pe7oG2cKF+UNbfuMUZE/0t2jule4ltzVZi4TgYIrP5N
o1gGkDTZqTJ4hsAnPvGqW83Zrdd8wmYaAguo1ofFwCWd5hoOJ2vcfgeeJoTCEyVh
tGGqAh8AGsMhYdLevqHoYZouQ3hJlcpyDF5nTlyj50DLQtZz64g=
=uJeS
-----END PGP SIGNATURE-----

--hr3uzs2vfclwp35n--
