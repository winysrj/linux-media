Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36052 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754487AbeFMIYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 04:24:42 -0400
Date: Wed, 13 Jun 2018 11:24:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Rob Herring <robh@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 2/2] media: ov5640: add support of module orientation
Message-ID: <20180613082438.j7w5knhxtjcdjxng@valkosipuli.retiisi.org.uk>
References: <1528709357-7251-1-git-send-email-hugues.fruchet@st.com>
 <1528709357-7251-3-git-send-email-hugues.fruchet@st.com>
 <20180612220628.GA18467@rob-hp-laptop>
 <0701a0f6-bc39-1754-55e2-1de9b9394b5b@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0701a0f6-bc39-1754-55e2-1de9b9394b5b@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 13, 2018 at 08:10:02AM +0000, Hugues FRUCHET wrote:
> Hi Rob, thanks for review,
> 
> On 06/13/2018 12:06 AM, Rob Herring wrote:
> > On Mon, Jun 11, 2018 at 11:29:17AM +0200, Hugues Fruchet wrote:
> >> Add support of module being physically mounted upside down.
> >> In this case, mirror and flip are enabled to fix captured images
> >> orientation.
> >>
> >> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >> ---
> >>   .../devicetree/bindings/media/i2c/ov5640.txt       |  3 +++
> > 
> > Please split bindings to separate patches.
> 
> OK, will do in next patchset.
> 
> > 
> >>   drivers/media/i2c/ov5640.c                         | 28 ++++++++++++++++++++--
> >>   2 files changed, 29 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> >> index 8e36da0..f76eb7e 100644
> >> --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> >> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> >> @@ -13,6 +13,8 @@ Optional Properties:
> >>   	       This is an active low signal to the OV5640.
> >>   - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
> >>   		   if any. This is an active high signal to the OV5640.
> >> +- rotation: integer property; valid values are 0 (sensor mounted upright)
> >> +	    and 180 (sensor mounted upside down).
> > 
> > Didn't we just add this as a common property? If so, just reference the
> > common definition. If not, it needs a common definition.
> > 
> 
> A common definition has been introduced by Sakari, I'm reusing it, see:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg132517.html
> 
> I would so propose:
>  >> +- rotation: as defined in
>  >> +	Documentation/devicetree/bindings/media/video-interfaces.txt.

Shouldn't the description still include the valid values? As far as I can
tell, these are ultimately device specific albeit more or less the same for
*this kind* of sensors.

The file already contains a reference to video-interfaces.txt.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
