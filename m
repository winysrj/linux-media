Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:40727 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbaCYPzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 11:55:23 -0400
Date: Tue, 25 Mar 2014 16:55:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/6] drm/i2c: tda998x: Move tda998x to a couple
 encoder/connector
Message-ID: <20140325165548.0065b639@armhf>
In-Reply-To: <1458827.cQ6aDWdh1W@avalon>
References: <cover.1395397665.git.moinejf@free.fr>
	<ad2d43d590302b67121338cfd4f9349a45942104.1395397665.git.moinejf@free.fr>
	<1458827.cQ6aDWdh1W@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 24 Mar 2014 23:39:01 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Jean-François,

Hi Laurent,

> Thank you for the patch.
> 
> On Friday 21 March 2014 09:17:32 Jean-Francois Moine wrote:
> > The 'slave encoder' structure of the tda998x driver asks for glue
> > between the DRM driver and the encoder/connector structures.
> > 
> > This patch changes the driver to a normal DRM encoder/connector
> > thanks to the infrastructure for componentised subsystems.
> 
> I like the idea, but I'm not really happy with the implementation. Let me try 
> to explain why below.
> 
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> >  drivers/gpu/drm/i2c/tda998x_drv.c | 323 +++++++++++++++++++----------------
> >  1 file changed, 188 insertions(+), 135 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c
> > b/drivers/gpu/drm/i2c/tda998x_drv.c index fd6751c..1c25e40 100644
> > --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> > +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> 
> [snip]
> 
> > @@ -44,10 +45,14 @@ struct tda998x_priv {
> > 
> >  	wait_queue_head_t wq_edid;
> >  	volatile int wq_edid_wait;
> > -	struct drm_encoder *encoder;
> > +	struct drm_encoder encoder;
> > +	struct drm_connector connector;
> >  };
> 
> [snip]
> 
> > -static int
> > -tda998x_probe(struct i2c_client *client, const struct i2c_device_id *id)
> > +static int tda_bind(struct device *dev, struct device *master, void *data)
> >  {
> > +	struct drm_device *drm = data;
> 
> This is the part that bothers me. You're making two assumptions here, that the 
> DRM driver will pass a struct drm_device pointer to the bind operation, and 
> that the I2C encoder driver can take control of DRM encoder and connector 
> creation. Although it could become problematic later, the first assumption 
> isn't too much of an issue for now. I'll thus focus on the second one.
> 
> The component framework isolate the encoder and DRM master drivers as far as 
> component creation and binding is concerned, but doesn't provide a way for the 
> two drivers to communicate together (nor should it). You're solving this by 
> passing a pointer to the DRM device to the encoder bind operation, making the 
> encoder driver create a DRM encoder and connector, and relying on the DRM core 
> to orchestrate CRTCs, encoders and connectors. You thus assume that the 
> encoder hardware should be represented by a DRM encoder object, and that its 
> output is connected to a connector that should be represented by a DRM 
> connector object. While this can work in your use case, that won't always hold 
> true. Hardware encoders can be chained together, while DRM encoders can't. The 
> DRM core has recently received support for bridge objects to overcome that 
> limitation. Depending on the hardware topology, a given hardware encoder 
> should be modeled as a DRM encoder or as a DRM bridge. That decision shouldn't 
> be taken by the encoder driver but by the DRM master driver. The I2C encoder 
> driver thus shouldn't create the DRM encoder and DRM connector itself.
> 
> I believe the encoder/master communication problem should be solved 
> differently. Instead of passing a pointer to the DRM device to the encoder 
> driver and making the encoder driver control DRM encoder and connector 
> creation, the encoder driver should instead create an object not visible to 
> userspace that can be retrieved by the DRM master driver (possibly through 
> registration with the DRM core, or by going through drvdata in the encoder's 
> struct device). The DRM master could use that object to communicate with the 
> encoder, and would register the DRM encoder and DRM connector itself based on 
> hardware topology.
> 
> > +	struct i2c_client *i2c_client = to_i2c_client(dev);
> > +	struct tda998x_priv *priv = i2c_get_clientdata(i2c_client);
> > +	struct drm_connector *connector = &priv->connector;
> > +	struct drm_encoder *encoder = &priv->encoder;
> > +	int ret;
> > +
> > +	if (!try_module_get(THIS_MODULE)) {
> > +		dev_err(dev, "cannot get module %s\n", THIS_MODULE->name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = drm_connector_init(drm, connector,
> > +				&connector_funcs,
> > +				DRM_MODE_CONNECTOR_HDMIA);
> 
> This is one example of the shortcomings I've explained above. An encoder 
> driver can't always know what connector type it is connected to. If I'm not 
> mistaken possible options here are DVII, DVID, HDMIA and HDMIB. It should be 
> up to the master driver to select the connector type based on its overall view 
> of the hardware, or even to a connector driver that would be bound to a 
> connector DT node (as proposed in https://www.mail-archive.com/devicetree@vger.kernel.org/msg16585.html).
	[snip]

The tda998x, as a HDMI transmitter, has to deal with both video and
audio.

Whereas the hardware connection schemes are the same in both worlds,
the way they are translated to computer objects are very different:

- video
	DRM card -> CRTCs -> encoders -> (bridges) -> connectors

- audio
	ALSA card -> CPUs -> (CODECs) -> CODECs

and it would be nice to have a common layout.

Actually, the tda998x is a slave encoder, that is, it plays the roles
of both encoder and connector. In the 2 DRM drivers (armada and tilcdc)
which use it, yes, the encoders and connectors are created by the main
DRM drivers, but, there is no notion of bridge, and, also, the encoder
is DRM_MODE_ENCODER_TMDS and the connector is DRM_MODE_CONNECTOR_HDMIA.
Then, nothing is changed in the global system working.

About the connector, yes, I let its type as hard-coded, but this could
be changed by configuration in the platform data or in the DT. Anyway,
there is nothing as such in the proposed patch

	'Add DT binding documentation for HDMI Connector'

I also dislike this patch because it adds a device which is of no use.
I had a same remark from Mark Brown about a tda998x CODEC proposal of
mine:

	hdmi_codec: hdmi-codec {
		compatible = "nxp,tda998x-codec";
		audio-ports = <0x03>, <0x04>;
	};

So, the next tda998x CODEC will be directly included in the tda998x
driver, the audio output being the HDMI connector. Here is the DT
definition I have for the Cubox:

&i2c0 {
	hdmi: hdmi-encoder {
		compatible = "nxp,tda9989";
		reg = <0x70>;
		interrupt-parent = <&gpio0>;
		interrupts = <27 IRQ_TYPE_EDGE_FALLING>;
		pinctrl-0 = <&pmx_camera>;
		pinctrl-names = "default";

		audio-ports = <0x03>, <0x04>;		/* 2 audio input ports */
		audio-port-names = "i2s", "spdif";
		#sound-dai-cells = <1>;

		port {					/* 1 video input port */
			hdmi_0: endpoint@0 {
				remote-endpoint = <&lcd0_0>;
			};
		};
	};
};

Back to the DRM device pointer given to the tda998x driver, as the
tda998x is an encoder/connector, it has no bridge function, so, there
is no need to add a complex API for information exchange between both
drivers.

Anyway, there is a big lack in my proposal: the tda998x encoder is
hard-coded to the first CRTC. This could be solved by a scan of the DT
and of the encoder list by the DRM driver, but I think that the actual
definitions as proposed by media/video-interfaces.txt are not easy to
use.

Do you think that a description as done for ALSA could work?

A sound card creation is done by a global sound configuration and a
description of the links between the card elements. Here is the tda998x
part of the Cubox audio card ('audio1' is the audio device):

	sound {
		compatible = "simple-audio-card";
		simple-audio-card,name = "Cubox Audio";

		simple-audio-card,dai-link@0 {		/* I2S - HDMI */
			format = "i2s";
			cpu {
				sound-dai = <&audio1 0>;	/* I2S output */
			};
			codec {
				sound-dai = <&hdmi 0>;		/* I2S input */
			};
		};

		simple-audio-card,dai-link@1 {		/* S/PDIF - HDMI */
			cpu {
				sound-dai = <&audio1 1>;	/* S/PDIF output */
			};
			codec {
				sound-dai = <&hdmi 1>;		/* S/PDIF input */
			};
		};
	};

Using the same elements, here is what could be the video card of the
Armada 510 with a panel, the tda998x and the display controller:

	video {
		compatible = "simple-video-card";

		simple-video-card,dvi-link {
			crtc {
				dvi = <&lcd0>;
			};
			encoder {
				dvi = <&panel>;
				connector-type = 7;	/* LVDS */
			};
		};
		simple-video-card,dvi-link {
			crtc {
				dvi = <&lcd0>;
			};
			encoder {
				dvi = <&hdmi>;
				connector-type = 11;	/* HDMI-A */
			};
		};
	};

	lcd0: lcd-controller@820000 {
		compatible = "marvell,armada-510-lcd";
		... hardware definitions ...
	};

	hdmi : hdmi-encoder {
		.. same as above, but without the video input port ..
	};

	panel: panel {
		.. panel parameters ..
	};

Then, the generic 'simple-video-card' has all elements to create the
DRM device.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
