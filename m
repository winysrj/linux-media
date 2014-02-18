Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47247 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbaBRPnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 10:43:16 -0500
Message-id: <53037F8F.3050302@samsung.com>
Date: Tue, 18 Feb 2014 16:43:11 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH] V4L: s5k6a3: Add DT binding documentation
References: <1387747620-24676-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1387747620-24676-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/12/13 22:27, Sylwester Nawrocki wrote:
> This patch adds DT binding documentation for the Samsung S5K6A3(YX)
> raw image sensor.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> This patch adds missing documentation [1] for the "samsung,s5k6a3"
> compatible. Rob, can you please merge it through your tree if it 
> looks OK ?

Anyone cares to Ack this patch so it can be merged through the media
tree ?

> Thanks,
> Sylwester
> 
> [1] http://www.spinics.net/lists/devicetree/msg10693.html
> 
> Changes since v3 (https://linuxtv.org/patch/20429):
>  - rephrased 'clocks' and 'clock-names' properties' description.
> ---
>  .../devicetree/bindings/media/samsung-s5k6a3.txt   |   33 ++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
> new file mode 100644
> index 0000000..cce01e8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
> @@ -0,0 +1,33 @@
> +Samsung S5K6A3(YX) raw image sensor
> +---------------------------------
> +
> +S5K6A3(YX) is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
> +and CCI (I2C compatible) control bus.
> +
> +Required properties:
> +
> +- compatible	: "samsung,s5k6a3";
> +- reg		: I2C slave address of the sensor;
> +- svdda-supply	: core voltage supply;
> +- svddio-supply	: I/O voltage supply;
> +- afvdd-supply	: AF (actuator) voltage supply;
> +- gpios		: specifier of a GPIO connected to the RESET pin;
> +- clocks	: should contain list of phandle and clock specifier pairs
> +		  according to common clock bindings for the clocks described
> +		  in the clock-names property;
> +- clock-names	: should contain "extclk" entry for the sensor's EXTCLK clock;
> +
> +Optional properties:
> +
> +- clock-frequency : the frequency at which the "extclk" clock should be
> +		    configured to operate, in Hz; if this property is not
> +		    specified default 24 MHz value will be used.
> +
> +The common video interfaces bindings (see video-interfaces.txt) should be
> +used to specify link to the image data receiver. The S5K6A3(YX) device
> +node should contain one 'port' child node with an 'endpoint' subnode.
> +
> +Following properties are valid for the endpoint node:
> +
> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> +  video-interfaces.txt.  The sensor supports only one data lane.

