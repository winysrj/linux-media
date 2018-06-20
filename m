Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36985 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754655AbeFTUB2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 16:01:28 -0400
Date: Wed, 20 Jun 2018 14:01:26 -0600
From: Rob Herring <robh@kernel.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH v2 2/3] dt-bindings: ov5640: Add "rotation" property
Message-ID: <20180620200126.GA22395@rob-hp-laptop>
References: <1529317759-28657-1-git-send-email-hugues.fruchet@st.com>
 <1529317759-28657-3-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529317759-28657-3-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 18, 2018 at 12:29:18PM +0200, Hugues Fruchet wrote:
> Add the rotation property to the list of optional properties
> for the OV5640 camera sensor.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov5640.txt | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
