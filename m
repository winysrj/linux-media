Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C91EC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4A82083D
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="plQ/soHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfCLPfq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:35:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35889 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfCLPfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:35:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id g18so3224793wru.3
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 08:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=BRVHufe2gCU0w3/Y7tnD+THdV1tpIiKRp561ZaSe67E=;
        b=plQ/soHTYXx2Xp+egQJTxMa0pFdY/JUUB2OSPBv8iX+D/zt2kAZkJvcEL5KLnpWRUM
         PXAVfRPARTMSeo50oGUj+WycivTvn/p0Yd2J6e4x+ncC3mV1QODILMQROwaQockNvFv3
         zXe0aNvX6L7tfIArJRWcQJ/LXiVOx6T+Rr0HWDRlAouv9mhyQTtg3MFZINWnS6WkW4vn
         /WlaKXKgZU1cCiJObycoPYYKRbKo2yu9YaYBbz/QYW0pSK3D9ngblRFmA9pF0e7ec/ep
         nf51tZbo0DH12HLhXWIwrBhugQkp0be7f8YGd0DzT6Wtw1M35/4InbMRwkf9aqNawUBo
         e3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=BRVHufe2gCU0w3/Y7tnD+THdV1tpIiKRp561ZaSe67E=;
        b=uI3/QGLbR6o1dAh02vY3LJoiYRe2Z4qx1u6yu3XTK/ozYRYaB7z9Ll51rMupUiub/r
         5mjyCVwJVseUavh0IyAuSp/FuFytHvYheQHZKyuaNw5xujoRBxKoWnBN64KqU61iPLdg
         2NSWUU3NSAKRIAbrXwDg8qYXgD0YYfu3IvMomJud0n/y2TnlgW3t99RMPSLYY/eJGj33
         CQsSdw/0uKbh6d3n23zA9ERN4rqp9EsKhlw6jS0Bp3dIKtwkXz0Fe1SAZ4TkFnGFkPJT
         eNXpnfnkLl/PV1ySWt02NO6pMW+uXdwh39IUw0fOQ2nn+R0qKesetk7Ct5PzzHeWQQtn
         rROQ==
X-Gm-Message-State: APjAAAUWNTQcML53Pjv/y7RD99Gj0BZnU4/xwa13VnHT5hVuIGh6T0ik
        K9TijozKllegLJjrfdSrayYXqA==
X-Google-Smtp-Source: APXvYqw7Q3hk7rCGNkFbINWaUG5ko4sYHT/m95Gf+cgCRPcfb/rIHqt1WMmhC7l344Ras71iEpsBvg==
X-Received: by 2002:a5d:4f02:: with SMTP id c2mr19668197wru.30.1552404944157;
        Tue, 12 Mar 2019 08:35:44 -0700 (PDT)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id d15sm24494550wrw.36.2019.03.12.08.35.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 08:35:35 -0700 (PDT)
References: <20190206151328.21629-1-rui.silva@linaro.org> <20190206151328.21629-9-rui.silva@linaro.org> <20190310214102.GA7578@pendragon.ideasonboard.com> <m3y35kdw7v.fsf@linaro.org> <20190312141046.GB4845@pendragon.ideasonboard.com>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v14 08/13] ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
In-reply-to: <20190312141046.GB4845@pendragon.ideasonboard.com>
Date:   Tue, 12 Mar 2019 15:35:33 +0000
Message-ID: <m3tvg8ds1m.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,
On Tue 12 Mar 2019 at 14:10, Laurent Pinchart wrote:
> Hi Rui,
>
> On Tue, Mar 12, 2019 at 02:05:24PM +0000, Rui Miguel Silva 
> wrote:
>> On Sun 10 Mar 2019 at 21:41, Laurent Pinchart wrote:
>> > Hi Rui,
>> >
>> > Thank you for the patch.
>> 
>> Where have you been for the latest 14 versions? :)
>
> Elsewhere I suppose :-)

eheh.

>
>> This is already merged, but... follow up patches can address 
>> your
>> issues bellow.
>
> I saw the driver and DT bindings patches merged in the media 
> tree for
> v5.2, where have the DT patches been merged ?

Good question, now that you talk I do not think they were merged.

>
>> > On Wed, Feb 06, 2019 at 03:13:23PM +0000, Rui Miguel Silva 
>> > wrote:
>> >> This patch adds the device tree nodes for csi, video 
>> >> multiplexer and mipi-csi besides the graph connecting the 
>> >> necessary
>> >> endpoints to make the media capture entities to work in imx7 
>> >> Warp
>> >> board.
>> >> 
>> >> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> >> ---
>> >>  arch/arm/boot/dts/imx7s-warp.dts | 51 
>> >>  ++++++++++++++++++++++++++++++++
>> >>  arch/arm/boot/dts/imx7s.dtsi     | 27 +++++++++++++++++
>> >
>> > I would have split this in two patches to make backporting 
>> > easier, but it's not a big deal.
>> >
>> > Please see below for a few additional comments.
>> >
>> >>  2 files changed, 78 insertions(+)
>> >> 
>> >> diff --git a/arch/arm/boot/dts/imx7s-warp.dts 
>> >> b/arch/arm/boot/dts/imx7s-warp.dts
>> >> index 23431faecaf4..358bcae7ebaf 100644
>> >> --- a/arch/arm/boot/dts/imx7s-warp.dts
>> >> +++ b/arch/arm/boot/dts/imx7s-warp.dts
>> >> @@ -277,6 +277,57 @@
>> >>  	status = "okay";
>> >>  };
>> >>  
>> >> +&gpr {
>> >> +	csi_mux {
>> >> +		compatible = "video-mux";
>> >> +		mux-controls = <&mux 0>;
>> >> +		#address-cells = <1>;
>> >> +		#size-cells = <0>;
>> >> +
>> >> +		port@1 {
>> >> +			reg = <1>;
>> >> +
>> >> +			csi_mux_from_mipi_vc0: endpoint {
>> >> +				remote-endpoint = 
>> >> <&mipi_vc0_to_csi_mux>;
>> >> +			};
>> >> +		};
>> >> +
>> >> +		port@2 {
>> >> +			reg = <2>;
>> >> +
>> >> +			csi_mux_to_csi: endpoint {
>> >> +				remote-endpoint = 
>> >> <&csi_from_csi_mux>;
>> >> +			};
>> >> +		};
>> >> +	};
>> >> +};
>> >> +
>> >> +&csi {
>> >> +	status = "okay";
>> >> +
>> >> +	port {
>> >> +		csi_from_csi_mux: endpoint {
>> >> +			remote-endpoint = <&csi_mux_to_csi>;
>> >> +		};
>> >> +	};
>> >> +};
>> >
>> > Shouldn't these two nodes, as well as port@1 of the mipi_csi 
>> > node, be moved to imx7d.dtsi ?
>> 
>> Yeah, I guess you are right here.
>> 
>> >
>> >> +
>> >> +&mipi_csi {
>> >> +	clock-frequency = <166000000>;
>> >> +	status = "okay";
>> >> +	#address-cells = <1>;
>> >> +	#size-cells = <0>;
>> >> +	fsl,csis-hs-settle = <3>;
>> >
>> > Shouldn't this be an endpoint property ? Different sensors 
>> > connected
>> > through different endpoints could have different timing
>> > requirements.
>> 
>> Hum... I see you point, even tho the phy hs-settle is a common
>> control. 
>
> I suppose we don't need to care about DT backward compatibility 
> if we
> make changes in the bindings for v5.2 ? Would you fix this, or 
> do you
> want a patch ?

I will try to take a look at this until end of week.

---
Cheers,
	Rui

