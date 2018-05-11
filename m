Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44759 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753280AbeEKOxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:53:22 -0400
Date: Fri, 11 May 2018 16:53:13 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] media: rcar-vin: Use FTEV for digital input
Message-ID: <20180511145313.GG19612@w540>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526032781-14319-6-git-send-email-jacopo+renesas@jmondi.org>
 <b3b6acfd-1006-b84f-f70f-29bbf6df85db@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5L6AZ1aJH5mDrqCQ"
Content-Disposition: inline
In-Reply-To: <b3b6acfd-1006-b84f-f70f-29bbf6df85db@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5L6AZ1aJH5mDrqCQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hans,

On Fri, May 11, 2018 at 12:28:55PM +0200, Hans Verkuil wrote:
> On 05/11/18 11:59, Jacopo Mondi wrote:
> > Since commit (015060cb "media: rcar-vin: enable field toggle after a set
> > number of lines for Gen3) the VIN generates an internal field signal
> > toggle after a fixed number of received lines, and uses the internal
> > field signal to drive capture operations. When capturing from digital
> > input, using FTEH driven field signal toggling messes up the received
> > image sizes. Fall back to use FTEV driven signal toggling when capturing
> > from digital input.
> >
> > As explained in the comment, this disables buffer overflow protection
> > for digital input capture, for which the FOE overflow might be used in
> > future.
>
> I don't know the details of the hardware, but this sounds dangerous.
>
> You should know that with HDMI input it is perfectly possible that you get
> more data than you should. I.e. instead of 1080 lines (assuming full HD)
> you might get more lines. This happens if the vertical sync is missed due
> to pin bounce when connecting a source.
>
> Other reasons for this are flaky signals, bad clocks, etc.
>
> It's rare, but it really happens.
>
> A good DMA engine will refuse to write more than fits in the buffer.
>
> If you disable that, then you will get overflows eventually.
>
> The reality with HDMI input is that you should never assume clean valid
> data. You do not control the source and it can send anything it likes.

Thanks for the informations. I agree HDMI input is lot of fun (-.-)
and we've seen weird things happening too.

With the patch Niklas has just sent that fixes the crop/compose
rectangle, also the previously in-place protection agains overflow has
been reverted, so this patch is not required anymore.

I re-send re-basing this on top of Niklas' latest fix.

Thanks
   j

>
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> > index ea7a120..8dc3455 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -685,11 +685,27 @@ static int rvin_setup(struct rvin_dev *vin)
> >  		break;
> >  	}
> >
> > -	if (vin->info->model == RCAR_GEN3) {
> > +	if (vin->info->model == RCAR_GEN3 &&
> > +	    vin->mbus_cfg.type == V4L2_MBUS_CSI2) {
> >  		/* Enable HSYNC Field Toggle mode after height HSYNC inputs. */
> >  		lines = vin->format.height / (halfsize ? 2 : 1);
> >  		dmr2 = VNDMR2_FTEH | VNDMR2_HLV(lines);
> >  		vin_dbg(vin, "Field Toogle after %u lines\n", lines);
>
> Typo: Toogle -> Toggle
>
> > +	} else if (vin->info->model == RCAR_GEN3 &&
> > +		   vin->mbus_cfg.type == V4L2_MBUS_PARALLEL) {
> > +		/*
> > +		 * FIXME
> > +		 * Section 26.3.17 specifies that for digital input there's no
> > +		 * need to program FTEH or FTEV to generate internal
> > +		 * field toggle signal to driver capture. Although when
> > +		 * running on GEN3 with digital input no EFE interrupt is ever
> > +		 * generated, and we need to rely on FTEV driven field signal
> > +		 * toggling, as using FTEH as in the CSI-2 case, messes up
> > +		 * the output image size. This implies no protection
> > +		 * against buffer overflow is in place for Gen3 digital input
> > +		 * capture.
> > +		 */
> > +		dmr2 = VNDMR2_FTEV;
> >  	} else {
> >  		/* Enable VSYNC Field Toogle mode after one VSYNC input. */
>
> Ditto. Search and replace?
>
> >  		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
> >
>
> Regards,
>
> 	Hans

--5L6AZ1aJH5mDrqCQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa9a5ZAAoJEHI0Bo8WoVY8XJIQAKBjPV9zqSQDl4AoeN8LN26j
PlcJUNf8NHaAbFfMZCjtepGelyupVw7rcljJxQ5G923tCB5fWMruqdqS1hKvsLRc
CghIYgTQFgJUJR02WduphDVBZd1imIDk4a8vGc5M2cmrmEjALuDKNuRjdAQwJ9d0
E57cDbbTTvYNK72m08tONZOTQqR49Z4gcvCYztYVixOisAxAsqC53jQy5JRi4b8i
4//dgLJz2oUDmciTKICFZbAZXlura5cKrRjPSz839lM33LeNOnd1x4s8/OsOuFmO
eZU4NwKmua0/bSJBG00H6aIILQwLaK7uPzaToljI9AJk4cf1R0uM/JUALGNs64Az
gOOSbEZDz10I+ymvqBhAHHP78NF++qcxV3oCgfISFuXOJhPThT2+SYETtDawz6mx
MK4J+Zlp16ZOALuzUiA19J9pl6v36hVDicGosov6yBDzKqX8AroAZEnFRpelTjgz
SHPoRXEB6byfZN5akuqLmNXKRyV2h7+ti/U/uhmkjiHBKD5RquCIV+4VF02wysAP
H/NC2xnt9TbF/tGOvnbKoNGg7BwPvL6td6zo9zIzrd12p20nSJbq7ubUQsa/ZfN0
/V04JjfvgZ3h8pSxug8iPHKABRGNrai+wV9jwNMHu+a7UDO0pLNMGRNu5igooFGY
b2NhGPM7VQbkaYxILcGF
=Qfz0
-----END PGP SIGNATURE-----

--5L6AZ1aJH5mDrqCQ--
