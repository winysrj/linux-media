Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04FDC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90DE52087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vyxYwxhc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfCLOHI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:07:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54253 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfCLOHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 10:07:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id e74so2802278wmg.3
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 07:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=JjMDIgYsSlgugTzudX3B0a2CM/FNaFwMHn2A0fAXZqQ=;
        b=vyxYwxhcyBQRX9DmbTwNt5jKAZyy73CZiMDoVyRD4+5Jxmd2xeKsg593wVusS474px
         kahyvFbIc9y7pGbvPreJNuEalZ0WLlgtI5mqb/Zl9RXNs5c/q5IBycolcqiQvba+BUVY
         e/3TYVM7yM6p2POXpE3vh2BOGtWQjWQJffauNkEJBeU6n3BfyZaCXiszXHeuIrrLeYIl
         A8I2aDdL8MEZKkUMGoRpLzZBJYliOHff/TosvYvrTAvW9XO2uTLjH7DBeXmst80lCUTf
         AhV8jcl6vqS3B7BqoCsgQX3N9PFOE1TkbBPw4/+UiyqTREYZRMXREuZg+DsemoMUWu+z
         snYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=JjMDIgYsSlgugTzudX3B0a2CM/FNaFwMHn2A0fAXZqQ=;
        b=pRPi2itsbZCQeBRPsBZ1z9t6O9Aa2ICTh2I1U6317PY0+RF4dqVocv756nIjyw4+dg
         FW/tl+44wvbGAGskCrFXPQFfWWW3FktsEccSzZsCGbF1wmmR7xljOGckY/CAs1o8M1Va
         gZeMmblk4V92NGRlrIVimup3ILcENw3mQHQKjndecLwWhD13ig8C0LouobBndqA4T/73
         p6ZSFeISe4JeU3IPfBPliQRK9T2sSaUgGAIrfPhlVBze5p5Yq0fmLDcpZHVFxBwoabtl
         qvA3O4tK4TFx9h7nYVGYrznuAtVJfkwBZes0TlQ7f7xgtkrWkEgE4aq8uCWO/CYAOcYS
         7tbg==
X-Gm-Message-State: APjAAAVzbtlOB+hwi8vpIgG8AAZE08uJMhbONK5BMM7csjlnNzaQmIY5
        HhEs4BTRyzNa7b86yKAS57zQHQ==
X-Google-Smtp-Source: APXvYqxiCW9Mp5W9iiC0g2nL+EWIYHeQU+BMzz2qPhGi43iyMmP07j1RdM5rsReEIxI7lpdnym/oUw==
X-Received: by 2002:a7b:c929:: with SMTP id h9mr2585256wml.106.1552399625040;
        Tue, 12 Mar 2019 07:07:05 -0700 (PDT)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id y22sm1293500wmj.6.2019.03.12.07.07.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 07:07:04 -0700 (PDT)
References: <20180517125033.18050-1-rui.silva@linaro.org> <20180517125033.18050-7-rui.silva@linaro.org> <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk> <m3tvr5xt9t.fsf@linaro.org> <20190310214834.GB7578@pendragon.ideasonboard.com>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v4 06/12] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <20190310214834.GB7578@pendragon.ideasonboard.com>
Date:   Tue, 12 Mar 2019 14:07:02 +0000
Message-ID: <m3wol4dw55.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,
On Sun 10 Mar 2019 at 21:48, Laurent Pinchart wrote:
> Hi Rui,
>
> On Fri, May 18, 2018 at 09:27:58AM +0100, Rui Miguel Silva 
> wrote:
>> Hi Sakari,
>> Thanks for the review.
>> On Fri 18 May 2018 at 06:58, Sakari Ailus wrote:
>> > On Thu, May 17, 2018 at 01:50:27PM +0100, Rui Miguel Silva 
>> > wrote:
>> >> Add bindings documentation for i.MX7 media drivers.
>> >> 
>> >> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> >> ---
>> >>  .../devicetree/bindings/media/imx7.txt        | 145 
>> >>  ++++++++++++++++++
>> >>  1 file changed, 145 insertions(+)
>> >>  create mode 100644 
>> >>  Documentation/devicetree/bindings/media/imx7.txt
>> >> 
>> >> diff --git 
>> >> a/Documentation/devicetree/bindings/media/imx7.txt 
>> >> b/Documentation/devicetree/bindings/media/imx7.txt
>> >> new file mode 100644
>> >> index 000000000000..161cff8e6442
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/media/imx7.txt
>> >> @@ -0,0 +1,145 @@
>> >> +Freescale i.MX7 Media Video Device
>> >> +==================================
>> >> +
>> >> +Video Media Controller node
>> >> +---------------------------
>> >
>> > Note that DT bindings document the hardware, they are as such 
>> > not Linux dependent.
>> 
>> This was removed in this series, however I removed it in the 
>> wrong 
>> patch, If you see patch 11/12 you will see this being removed. 
>> I will
>> fix this in v5. Thanks for notice it.
>> 
>> >> +
>> >> +This is the media controller node for video capture 
>> >> support. 
>> >> It is a
>> >> +virtual device that lists the camera serial interface nodes 
>> >> that the
>> >> +media device will control.
>> >
>> > Ditto.
>> >
>> >> +
>> >> +Required properties:
>> >> +- compatible : "fsl,imx7-capture-subsystem";
>> >> +- ports      : Should contain a list of phandles pointing 
>> >> to 
>> >> camera
>> >> +		sensor interface port of CSI
>> >> +
>> >> +example:
>> >> +
>> >> +capture-subsystem {
>> >
>> > What's the purpose of this node, if you only refer to another 
>> > device? This one rather does not look like a real device at 
>> > all.
>> >
>> >> +	compatible = "fsl,imx7-capture-subsystem";
>> >> +	ports = <&csi>;
>> >> +};
>> >> +
>> >> +
>> >> +mipi_csi2 node
>> >> +--------------
>> >> +
>> >> +This is the device node for the MIPI CSI-2 receiver core in 
>> >> i.MX7 SoC. It is
>> >> +compatible with previous version of Samsung D-phy.
>> >> +
>> >> +Required properties:
>> >> +
>> >> +- compatible    : "fsl,imx7-mipi-csi2";
>> >> +- reg           : base address and length of the register 
>> >> set 
>> >> for the device;
>> >> +- interrupts    : should contain MIPI CSIS interrupt;
>> >> +- clocks        : list of clock specifiers, see
>> >> + 
>> >> Documentation/devicetree/bindings/clock/clock-bindings.txt 
>> >> for 
>> >> details;
>> >> +- clock-names   : must contain "pclk", "wrap" and "phy" 
>> >> entries, matching
>> >> +                  entries in the clock property;
>> >> +- power-domains : a phandle to the power domain, see
>> >> + 
>> >> Documentation/devicetree/bindings/power/power_domain.txt for 
>> >> details.
>> >> +- reset-names   : should include following entry "mrst";
>> >> +- resets        : a list of phandle, should contain reset 
>> >> entry of
>> >> +                  reset-names;
>> >> +- phy-supply    : from the generic phy bindings, a phandle 
>> >> to 
>> >> a regulator that
>> >> +	          provides power to MIPI CSIS core;
>> >> +- bus-width     : maximum number of data lanes supported 
>> >> (SoC 
>> >> specific);
>> >> +
>> >> +Optional properties:
>> >> +
>> >> +- clock-frequency : The IP's main (system bus) clock 
>> >> frequency 
>> >> in Hz, default
>> >> +		    value when this property is not specified is 
>> >> 166 MHz;
>> >> +
>> >> +port node
>> >> +---------
>> >> +
>> >> +- reg		  : (required) can take the values 0 or 1, 
>> >> where 0 is the
>> >> +                     related sink port and port 1 should be 
>> >> the source one;
>> >> +
>> >> +endpoint node
>> >> +-------------
>> >> +
>> >> +- data-lanes    : (required) an array specifying active 
>> >> physical MIPI-CSI2
>> >> +		    data input lanes and their mapping to logical 
>> >> lanes; the
>> >> +		    array's content is unused, only its length is 
>> >> meaningful;
>> >> +
>> >> +- fsl,csis-hs-settle : (optional) differential receiver 
>> >> (HS-RX) settle time;
>> >
>> > Could you calculate this, as other drivers do? It probably 
>> > changes
>> > depending on the device runtime configuration.
>> 
>> The only reference to possible values to this parameter is 
>> given 
>> by table in [0], can you point me out the formula for imx7 in 
>> the
>> documentation?
>> 
>> [0] https://community.nxp.com/thread/463777
>
> Can't you use the values from that table ? :-) You can get the 
> link
> speed by querying the connected subdev and reading its
> V4L2_CID_PIXEL_RATE control.

Yeah, I good point to add support for others subdev's. I will try
to add your comments in a follow up series.

---
Cheers,
	Rui


