Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41179 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbeKHTpw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 14:45:52 -0500
Date: Thu, 8 Nov 2018 11:11:01 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: kieran.bingham+renesas@ideasonboard.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v4 3/4] media: i2c: Add MAX9286 driver
Message-ID: <20181108101101.GE24024@w540>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-4-kieran.bingham@ideasonboard.com>
 <bfae74db-aa54-32b3-966b-b8d17f2e366b@ideasonboard.com>
 <898b4698-c3c3-9d38-e117-6a4274ba2ca4@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3O1VwFp74L81IIeR"
Content-Disposition: inline
In-Reply-To: <898b4698-c3c3-9d38-e117-6a4274ba2ca4@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3O1VwFp74L81IIeR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Luca, Kieran,
    sorry to jump up, but I feel this should be clarified.

On Wed, Nov 07, 2018 at 06:24:18PM +0100, Luca Ceresoli wrote:
> Hi Kieran,
>
> thanks for the clarification. One additional note below.
>
> On 07/11/18 16:06, Kieran Bingham wrote:
> > Hi Luca
> >
> > <Top posting for new topic>
> >
> >> <lucaceresoli> kbingham: hi, I'm looking at your GMSL v4 patches
> >> <lucaceresoli> kbingham: jmondi helped me in understanding parts of it, but I still have a question
> >> <lucaceresoli> kbingham: are the drivers waiting for the established link before the remote chips are accessed? where?
> >
> > I'm replying here rather than spam the IRC channel with a big paste.
> > It's also a useful description to the probe sequence, so I've kept it
> > with the driver posting.
> >
> > I hope the following helps illustrate the sequences which are involved:
> >
> > max9286_probe()
> >  - max9286_i2c_mux_close() # Disable all links
> >  - max9286_configure_i2c # Configure early communication settings
> >  - max9286_init():
> >    - regulator_enable() # Power up all cameras
> >    - max9286_setup() # Most link setup is done here.
> >    ... Set up v4l2/async/media-controller endpoints
> >    - max9286_i2c_mux_init() # Start configuring cameras:
> >      - i2c_mux_alloc() # Create our mux device
> >      - for_each_source(dev, source)
> >            i2c_mux_add_adapter() # This is where sensors get probed.
> >
> > So yes sensors are only communicated with once the link is brought up as
> > much as possible.
>
> For the records, an additional bit of explanation I got from Kieran via IRC.
>
> The fact that link is already up when the sensors are probed is due to
> the fact that the power regulator has a delay of *8 seconds*. This is
> intended, because there's an MCU on the camera modules that talks on the
> I2C bus during that time, and thus the drivers need to wait after it's done.

The 8sec delay is due to the fact an integrated MCU on the remote
camera module programs the local sensor and the serializer intgrated
in the module in to some default configuration state. At power up, we
just want to let it finish, with all reverse channels closed
(camera module -> SoC direction) not to have the MCU transmitted
messages repeated to the local side (our remote serializer does repeat
messages not directed to it on it's remote side, as our local
deserialier does).

The "link up" thing is fairly more complicated for GMSL than just
having a binary "on" or "off" mode. This technology defines two different
"channels", a 'configuration-channel' for transmitting control messages
on the serial link (i2c messages for the deserializer/serializer pair
this patches support) and a 'video-channel' for transmission of
high-speed data, such as, no surprise, video and images :)

GMSL also defines two "link modes": a clock-less "configuration link"
and an high-speed "video link". The "configuration link" is available a
few msec after power up (roughly), while the "video link" needs a pixel
clock to be supplied to the serializer for it to enter this mode and
be able to lock the status between itself and the deserializer. Then it can
begin serializing video data.

The 'control channel' is available both when the link is in
'configuration' and 'video' mode, while the 'video' channel is
available only when the link is in 'video' mode (or, to put it more
simply: you can send i2c configuration messages while the link is
serializing video).

Our implementation uses the link in 'configuration mode' during the
remote side programming phase, at 'max9286_i2c_mux_init()' time, with
the 'max9286_i2c_mux_select()' function enabling selectively the
'configuration link' of each single remote end. It probes the remote device
by instantiating a new i2c_adapter connected to the mux, one for each
remote end, and performs the device configuration by initially using its
default power up i2c address (it is safe to do so, all other links are
closed), then changes the remote devices address to an unique one
(as our devices allows us to do so, otherwise you should use the
deserializer address translation feature to mask and translate the
remote addresses).

Now all remote devices have an unique i2c address, and we can operate
with all 'configuration links' open with no risk of i2c addresses
collisions.

At this point when we want to start the video stream, we send a
control message to the remote device, which enables the pixel clock
output from the image sensor, and activate the 'video channel' on the
remote serializer. The local deserializer makes sure all 'video links'
are locked (see 'max9286_check_video_links()') and at this point we
can begin serializing/deserializing video data.

As you can see, the initial delay only plays a role in avoiding
collision before we properly configure the channels and the i2c
addresses. The link setup phase is instead an integral part of the
system configuration, and there are no un-necessary delays used to
work around it setup procedure.

Does this help clarifying the system startup procedure?

Thanks
   j
>
> This delay happens before max9286_setup() is called.
>
> > Because the sensors are i2c devices on the i2c_mux - they are not probed
> > until their adapters are created and added.
> >
> > At this stage the i2c-mux core framework will iterate all the devices
> > described by the DT for that adapter.
> >
> > As each one is probed - the i2c_mux framework will call
> > max9286_i2c_mux_select() and enable only the single link.
> >
> > This allows us to configure each camera independently
> >
> > (which is essential because they are all configured to the same i2c
> > address by default at power on)
> >
> >
> > Hope this helps, and feel free to ask if you have any more questions.
> --
> Luca

--3O1VwFp74L81IIeR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb5Au1AAoJEHI0Bo8WoVY8GGYQAIadUPYYVsFiSuKMHHy19nAw
fuVtok+htzAClSQD9g+EzT7qnwdKNliQLlhMsplvq0zGBvhiih8kl64BQ0j+n3Zp
iKdtulFlz2vvC8XZAC37NhQMl52NjtRcsxJNgFW5pxMkso8CEubPO8LbbsM74Ke+
ELu6rPXEkTudmGGbDlUooA/8FZjX2jehmIXdZ/MshLLl790mN6PCsJTP2U7VWCJE
hPdwuKwtzFR58XVCFiJuANZj7USnPp6oj1rSC9awhEKmPGJ3f7YzuIDnsLbHd2vp
rEWQczRJQBbP/gn4RDCC6Ty10X0rUjciodHQILRfOp09iYkAtGQskBTmCFwGQ6FS
iYIX+xL4KmOZnv9xyJ73euTsVhOoQzFIL6/jGX2hJO2aV6XE+7MdnhFu2QHPEd4H
aIFuIQZig8h9J4Bxgx+TPPFsP3wvF1Otdaha3jGSfbru3uYF5qy9M7YAo/Bi6+NM
jQJ4VyB+UBcG3WflZNYQ/reNNm9F+pYyVjIJt4W8OZ5/pQfQPdZ92fo0cVJ7NbzK
0Rfc6ZDXfOQs73ftxfpPYfo7P7v3MBZW7FUbaOFXNtWf8IIKhQERNloWrCKVReFv
AdhMCToGZ0T5G/ZTJipG8a1WZBd2eWHF5ut/nn70z6lqh6aGnog3mdaqHNF8II7d
SY8jAWdbmBtu3nj3Dmet
=WVST
-----END PGP SIGNATURE-----

--3O1VwFp74L81IIeR--
