Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39747 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeJOXKe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 19:10:34 -0400
Date: Mon, 15 Oct 2018 17:24:46 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Bobrowicz <sam@elite-embedded.com>,
        "slongerbeam@gmail.com" <slongerbeam@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "daniel@zonque.org" <daniel@zonque.org>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 1/4] media: ov5640: fix resolution update
Message-ID: <20181015152446.GF21294@w540>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
 <1539067682-60604-2-git-send-email-sam@elite-embedded.com>
 <20181010105804.GD7677@w540>
 <5292714.SW9firoZdu@avalon>
 <0295fe15-6802-ecd9-f42d-391184fc1344@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ni93GHxFvA+th69W"
Content-Disposition: inline
In-Reply-To: <0295fe15-6802-ecd9-f42d-391184fc1344@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ni93GHxFvA+th69W
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,

On Mon, Oct 15, 2018 at 03:13:12PM +0000, Hugues FRUCHET wrote:
> Hi Laurent, Jacopo, Sam,
>
> I'm also OK to change to a simpler alternative;
> - drop the "restore" step

Do you mean the restore step at the end of 'ov5640_restore_mode()' ?
I agree, I've been carrying this one [1] in my tree for some time now.
I just didn't send it because of the too many issues in flight on this
driver.

> - send the whole init register sequence + mode changes + format changes
> at streamon
>

This might be a first step in my opinion too, yes.

> is this what you have in mind Laurent ?

I know Laurent does not fully agree with me on this, but I would like
to have Maxime's series on clock tree handling merged and tested on
CSI-2 first before adding more patches to the pile of pending items on
ov5640. I hope to have time to test them on CSI-2 this week before
ELC-E.

Steve, you're the driver maintainer do you have preferences here?

Also, if this might be useful, I would like to help co-maintaining the
driver (with possibily other people, possibly with the sensor wired in
DVP mode), and help establishing priorities, as this driver needs some
love, but one item at the time to avoid getting lost in too many
pending changes as it happened recently :)

Thanks
   j

[1]
    media: ov5640: Do not restore format at power up

    Do not force restoring the last applied capture format during sensor power up
    as it will be re-set at s_stream time.

    Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index b226946..17ee55b 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1737,12 +1737,10 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
        if (ret)
                return ret;

-       /* now restore the last capture mode */
-       ret = ov5640_set_mode(sensor, &ov5640_mode_init_data);
-       if (ret < 0)
-               return ret;
+       sensor->pending_mode_change = true;
+       sensor->pending_fmt_change = true;

-       return ov5640_set_framefmt(sensor, &sensor->fmt);
+       return 0;
 }

 static void ov5640_power(struct ov5640_dev *sensor, bool enable)

>
> On 10/10/2018 02:41 PM, Laurent Pinchart wrote:
> > Hi Jacopo,
> >
> > On Wednesday, 10 October 2018 13:58:04 EEST jacopo mondi wrote:
> >> Hi Sam,
> >>     thanks for the patch, I see the same issue you reported, but I
> >> think this patch can be improved.
> >>
> >> (expanding the Cc list to all people involved in recent ov5640
> >> developemts, not just for this patch, but for the whole series to look
> >> at. Copying names from another series cover letter, hope it is
> >> complete.)
> >>
> >> On Mon, Oct 08, 2018 at 11:47:59PM -0700, Sam Bobrowicz wrote:
> >>> set_fmt was not properly triggering a mode change when
> >>> a new mode was set that happened to have the same format
> >>> as the previous mode (for example, when only changing the
> >>> frame dimensions). Fix this.
> >>>
> >>> Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
> >>> ---
> >>>
> >>>   drivers/media/i2c/ov5640.c | 8 ++++----
> >>>   1 file changed, 4 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >>> index eaefdb5..5031aab 100644
> >>> --- a/drivers/media/i2c/ov5640.c
> >>> +++ b/drivers/media/i2c/ov5640.c
> >>> @@ -2045,12 +2045,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
> >>>
> >>>   		goto out;
> >>>
> >>>   	}
> >>>
> >>> -	if (new_mode != sensor->current_mode) {
> >>> +
> >>> +	if (new_mode != sensor->current_mode ||
> >>> +	    mbus_fmt->code != sensor->fmt.code) {
> >>> +		sensor->fmt = *mbus_fmt;
> >>>
> >>>   		sensor->current_mode = new_mode;
> >>>   		sensor->pending_mode_change = true;
> >>>
> >>> -	}
> >>> -	if (mbus_fmt->code != sensor->fmt.code) {
> >>> -		sensor->fmt = *mbus_fmt;
> >>>
> >>>   		sensor->pending_fmt_change = true;
> >>>
> >>>   	}
> >>
> >> How I did reproduce the issue:
> >>
> >> # Set 1024x768 on ov5640 without changing the image format
> >> # (default image size at startup is 640x480)
> >> $ media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/1024x768 field:none]"
> >>    sensor->pending_mode_change = true; //verified this flag gets set
> >>
> >> # Start streaming, after having configured the whole pipeline to work
> >> # with 1024x768
> >> $  yavta -c10 -n4 -f UYVY -s 1024x768 /dev/video4
> >>     Unable to start streaming: Broken pipe (32).
> >>
> >> # Inspect which part of pipeline validation went wrong
> >> # Turns out the sensor->fmt field is not updated, and when get_fmt()
> >> # is called, the old one is returned.
> >> $ media-ctl -e "ov5640 2-003c" -p
> >>    ...
> >>    [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601
> >> quantization:full-range] ^^^ ^^^
> >>
> >> So yes, sensor->fmt is not udapted as it should be when only image
> >> resolution is changed.
> >>
> >> Although I still see value in having two separate flags for the
> >> 'mode_change' (which in ov5640 lingo is resolution) and 'fmt_change' (which
> >> in ov5640 lingo is the image format), and write their configuration to
> >> registers only when they get actually changed.
> >>
> >> For this reasons I would like to propse the following patch which I
> >> have tested by:
> >> 1) changing resolution only
> >> 2) changing format only
> >> 3) change both
> >>
> >> What do you and others think?
> >
> > I think that the format setting code should be completely rewritten, it's
> > pretty much unmaintainable as-is.
> >
> >> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >> index eaefdb5..e392b9d 100644
> >> --- a/drivers/media/i2c/ov5640.c
> >> +++ b/drivers/media/i2c/ov5640.c
> >> @@ -2020,6 +2020,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
> >>          struct ov5640_dev *sensor = to_ov5640_dev(sd);
> >>          const struct ov5640_mode_info *new_mode;
> >>          struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
> >> +       struct v4l2_mbus_framefmt *fmt;
> >>          int ret;
> >>
> >>          if (format->pad != 0)
> >> @@ -2037,22 +2038,19 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
> >>          if (ret)
> >>                  goto out;
> >>
> >> -       if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> >> -               struct v4l2_mbus_framefmt *fmt =
> >> -                       v4l2_subdev_get_try_format(sd, cfg, 0);
> >> +       if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> >> +               fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
> >> +       else
> >> +               fmt = &sensor->fmt;
> >>
> >> -               *fmt = *mbus_fmt;
> >> -               goto out;
> >> -       }
> >> +       *fmt = *mbus_fmt;
> >>
> >>          if (new_mode != sensor->current_mode) {
> >>                  sensor->current_mode = new_mode;
> >>                  sensor->pending_mode_change = true;
> >>          }
> >> -       if (mbus_fmt->code != sensor->fmt.code) {
> >> -               sensor->fmt = *mbus_fmt;
> >> +       if (mbus_fmt->code != sensor->fmt.code)
> >>                  sensor->pending_fmt_change = true;
> >> -       }
> >>   out:
> >>          mutex_unlock(&sensor->lock);
> >>          return ret;
> >>
> >>>   out:
> >>> --
> >>> 2.7.4
> >
> >
>
> BR,
> Hugues.

--ni93GHxFvA+th69W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbxLE+AAoJEHI0Bo8WoVY8ffAP/1RhRIRWTZMYbIanZqHktbEw
ygSZheBA6mf2pPBFUZBBdrc+zIuOFvsgwshZ7aqbdng8h7ScoNwZKd1uCidPhqzq
Sh0yEQ1igVo2BRrT73n3LtI3T43HO2VjuZY1jxYp2pV0eKTNCuZm5DV2j5tnJMdF
rqGOESe/qv6Eto5hK5AuFKfbzvfTkTwmvBzMGvfARLX9N6QYTBuIBjgvWWrr17BJ
v7bw5n1a4ORtfHCmJI5SmdF3N9Er7QZHEO5p+c3O7zZELeaO+JVYh0LYzA4fG3VO
YTdbs18WGE+8NEXblPvcCPKz9R5QT1w4liWdEcnni1VuzB79dsvThtsV2Ymi6rvY
h7nK5/wDvKzWzaeWsHsaYUBwxOOONFOWfnttD4fQtOVVvS88BWo7H+HExAkozMio
M4rE/iVaMmHkPm48w9iM3higrbCrUtkdv0wU6/24FNsULbrUAt03o7jR0kmtEIY1
jCyposv5HgIjC3pIyGDLjg/BH2KZvLA7dOhsBj9I+LbyAHXRFfCteHPH4jzSG6F0
Cn1mFgWlwih6biFbzLVzW4FTgyH1yKslFDJ3MSjQFkyFaD/IFuLgJ4wWj1CZv4Ie
cFXwRJys9sHodaUkSfmbL0rQpkjgLKtezyhGhoVravTARjKzby3mLvpBOpOA4ygp
r/R412bdY95ljCIp4IlO
=0wed
-----END PGP SIGNATURE-----

--ni93GHxFvA+th69W--
