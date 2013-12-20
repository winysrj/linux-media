Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:51451 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3LTXRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 18:17:21 -0500
Message-ID: <52B4CFFD.40409@gmail.com>
Date: Sat, 21 Dec 2013 00:17:17 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/6] V4L: s5k6a3: Add DT binding documentation
References: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com> <1382033211-32329-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1382033211-32329-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2013 08:06 PM, Sylwester Nawrocki wrote:
> This patch adds binding documentation for the Samsung S5K6A3(YX)
> raw image sensor.
>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>

Hi Mauro,

Can we merge it now without a DT binding maintainer Ack ?
There was no comments for 2 months and I believe the Ack is not mandatory
for this kind of standard binding and very similar binding has been already
reviewed (for the S5K5BAF sensor).

I just updated slightly the clock/clock-names property description, so I
would post patch [1] to the mailing lists before adding it to a pull 
request.

Thanks,
Sylwester

[1] 
http://git.linuxtv.org/snawrocki/samsung.git/commitdiff/4249788ea8c9b9d9bc95cd088351e2cdda1838f6

> ---
> Changes since v2:
>   - added AF regulator supply.
> ---
>   .../devicetree/bindings/media/samsung-s5k6a3.txt   |   32 ++++++++++++++++++++
>   1 file changed, 32 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
>
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
> new file mode 100644
> index 0000000..3806e77
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
> @@ -0,0 +1,32 @@
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
> +- clocks	: should contain the sensor's EXTCLK clock specifier,
> +		  from common clock bindings;
> +- clock-names	: should contain "extclk" entry;
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
