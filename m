Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35588 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754452AbeFMHnl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 03:43:41 -0400
Date: Wed, 13 Jun 2018 10:43:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rob Herring <robh@kernel.org>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 2/2] media: ov5640: add support of module orientation
Message-ID: <20180613074339.xfyxguj6jo56kqnz@valkosipuli.retiisi.org.uk>
References: <1528709357-7251-1-git-send-email-hugues.fruchet@st.com>
 <1528709357-7251-3-git-send-email-hugues.fruchet@st.com>
 <20180612220628.GA18467@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180612220628.GA18467@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob, Hugues,

On Tue, Jun 12, 2018 at 04:06:28PM -0600, Rob Herring wrote:
> On Mon, Jun 11, 2018 at 11:29:17AM +0200, Hugues Fruchet wrote:
> > Add support of module being physically mounted upside down.
> > In this case, mirror and flip are enabled to fix captured images
> > orientation.
> > 
> > Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> > ---
> >  .../devicetree/bindings/media/i2c/ov5640.txt       |  3 +++
> 
> Please split bindings to separate patches.
> 
> >  drivers/media/i2c/ov5640.c                         | 28 ++++++++++++++++++++--
> >  2 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> > index 8e36da0..f76eb7e 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> > @@ -13,6 +13,8 @@ Optional Properties:
> >  	       This is an active low signal to the OV5640.
> >  - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
> >  		   if any. This is an active high signal to the OV5640.
> > +- rotation: integer property; valid values are 0 (sensor mounted upright)
> > +	    and 180 (sensor mounted upside down).
> 
> Didn't we just add this as a common property? If so, just reference the 
> common definition. If not, it needs a common definition.

The common definition is there --- and this text is actually the same as
for the smiapp DT bindings --- which you acked. :-) I thought this would be
fine as well, and this patch is actually already in a pull request to
Mauro.

I put the smiapp bindings to the same patch with the driver change as they
were pretty small both but we'll split these in the future.

I've marked the pull request as deferred for now; let me know whether
you're still ok with this going in as such.

Thanks.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
