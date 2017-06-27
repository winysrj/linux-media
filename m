Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34876 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751312AbdF0FhR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 01:37:17 -0400
Date: Tue, 27 Jun 2017 08:36:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Subject: Re: [PATCH v1 2/6] [media] ov9650: add device tree support
Message-ID: <20170627053642.GW12407@valkosipuli.retiisi.org.uk>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-3-git-send-email-hugues.fruchet@st.com>
 <20170626163102.GQ12407@valkosipuli.retiisi.org.uk>
 <D780984B-70A1-4E9C-A887-DD2CBAAC7CCA@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D780984B-70A1-4E9C-A887-DD2CBAAC7CCA@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 26, 2017 at 07:46:34PM +0200, H. Nikolaus Schaller wrote:
> Hi,
> 
> > Am 26.06.2017 um 18:31 schrieb Sakari Ailus <sakari.ailus@iki.fi>:
> > 
> > Hi Hugues,
> > 
> > On Thu, Jun 22, 2017 at 05:05:38PM +0200, Hugues Fruchet wrote:
> >> @@ -1545,15 +1577,22 @@ static int ov965x_remove(struct i2c_client *client)
> >> }
> >> 
> >> static const struct i2c_device_id ov965x_id[] = {
> >> -	{ "OV9650", 0 },
> >> -	{ "OV9652", 0 },
> >> +	{ "OV9650", 0x9650 },
> >> +	{ "OV9652", 0x9652 },
> > 
> > This change does not appear to match with the patch description nor it the
> > information is used. How about not changing it, unless there's a reason to?
> > The same for the data field of the of_device_id array below.
> 
> I think it could/should be used to check if the camera chip that is found
> by reading the product-id and version registers does match what the device
> tree expects and abort probing on a mismatch.

Makes sense. But it should be a separate patch, shouldn't it?

You could also put the id to the ops struct, and choose the ops struct that
way. Entirely up to you.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
