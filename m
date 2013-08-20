Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:39923 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3HTMxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 08:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <52135A29.80203@samsung.com>
References: <1376644845-10422-1-git-send-email-arun.kk@samsung.com>
	<1376644845-10422-2-git-send-email-arun.kk@samsung.com>
	<52135A29.80203@samsung.com>
Date: Tue, 20 Aug 2013 18:23:14 +0530
Message-ID: <CALt3h78N=BA1_6LmuYkrpKBWwEMx_6hWUftXrKKT0+FFGn-7_g@mail.gmail.com>
Subject: Re: [PATCH v6 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com, Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Aug 20, 2013 at 5:29 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Cc: Pawel, Kumar
>
> On 08/16/2013 11:20 AM, Arun Kumar K wrote:
>> From: Shaik Ameer Basha <shaik.ameer@samsung.com>
>>
>> This patch adds support for media device for EXYNOS5 SoCs.
>> The current media device supports the following ips to connect
>> through the media controller framework.
>>
>> * MIPI-CSIS
>>   Support interconnection(subdev interface) between devices
>>
>> * FIMC-LITE
>>   Support capture interface from device(Sensor, MIPI-CSIS) to memory
>>   Support interconnection(subdev interface) between devices
>>
>> * FIMC-IS
>>   Camera post-processing IP having multiple sub-nodes.
>>
>> G-Scaler will be added later to the current media device.
>>
>> The media device creates two kinds of pipelines for connecting
>> the above mentioned IPs.
>> The pipeline0 is uses Sensor, MIPI-CSIS and FIMC-LITE which captures
>> image data and dumps to memory.
>> Pipeline1 uses FIMC-IS components for doing post-processing
>> operations on the captured image and give scaled YUV output.
>>
>> Pipeline0
>>   +--------+     +-----------+     +-----------+     +--------+
>>   | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | Memory |
>>   +--------+     +-----------+     +-----------+     +--------+
>>
>> Pipeline1
>>  +--------+      +--------+     +-----------+     +-----------+
>>  | Memory | -->  |  ISP   | --> |    SCC    | --> |    SCP    |
>>  +--------+      +--------+     +-----------+     +-----------+
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  .../devicetree/bindings/media/exynos5-mdev.txt     |  126 ++
>>  drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1210 ++++++++++++++++++++
>>  drivers/media/platform/exynos5-is/exynos5-mdev.h   |  126 ++
>>  3 files changed, 1462 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
>>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-mdev.txt b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>> new file mode 100644
>> index 0000000..b1299e2
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>
> Sorry, I missed this previously. How about renaming this file to something
> more specific to the subsystem it describes, e.g. exynos5250-camera.txt ?
>
>> @@ -0,0 +1,126 @@
>> +Samsung EXYNOS5 SoC Camera Subsystem
>> +------------------------------------
>> +
>> +The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
>> +represented by separate device tree nodes. Currently this includes: FIMC-LITE,
>> +MIPI CSIS and FIMC-IS.
>> +
>> +The sub-device nodes are referenced using phandles in the common 'camera' node
>> +which also includes common properties of the whole subsystem not really
>> +specific to any single sub-device, like common camera port pins or the common
>> +camera bus clocks.
>> +
>> +Common 'camera' node
>> +--------------------
>> +
>> +Required properties:
>> +
>> +- compatible         : must be "samsung,exynos5250-fimc"
>> +- clocks             : list of clock specifiers, corresponding to entries in
>> +                          the clock-names property;
>> +- clock-names                : must contain "sclk_bayer" entry
>> +- samsung,csis               : list of phandles to the mipi-csis device nodes
>> +- samsung,fimc-lite  : list of phandles to the fimc-lite device nodes
>> +- samsung,fimc-is    : phandle to the fimc-is device node
>> +
>> +The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
>> +to define a required pinctrl state named "default".
>> +
>> +'parallel-ports' node
>> +---------------------
>> +
>> +This node should contain child 'port' nodes specifying active parallel video
>> +input ports. It includes camera A, camera B and RGB bay inputs.
>> +'reg' property in the port nodes specifies the input type:
>> + 1 - parallel camport A
>> + 2 - parallel camport B
>> + 5 - RGB camera bay
>> +
>> +3, 4 are for MIPI CSI-2 bus and are already described in samsung-mipi-csis.txt
>> +
>> +Image sensor nodes
>> +------------------
>> +
>> +The sensor device nodes should be added to their control bus controller (e.g.
>> +I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
>> +using the common video interfaces bindings, defined in video-interfaces.txt.
>> +
>> +Example:
>> +
>> +     aliases {
>> +             fimc-lite0 = &fimc_lite_0
>> +     };
>> +
>> +     /* Parallel bus IF sensor */
>> +     i2c_0: i2c@13860000 {
>> +             s5k6aa: sensor@3c {
>> +                     compatible = "samsung,s5k6aafx";
>> +                     reg = <0x3c>;
>> +                     vddio-supply = <...>;
>> +
>> +                     clock-frequency = <24000000>;
>> +                     clocks = <...>;
>> +                     clock-names = "mclk";
>> +
>> +                     port {
>> +                             s5k6aa_ep: endpoint {
>> +                                     remote-endpoint = <&fimc0_ep>;
>> +                                     bus-width = <8>;
>> +                                     hsync-active = <0>;
>> +                                     vsync-active = <1>;
>> +                                     pclk-sample = <1>;
>> +                             };
>> +                     };
>> +             };
>> +     };
>> +
>> +     /* MIPI CSI-2 bus IF sensor */
>> +     s5c73m3: sensor@1a {
>> +             compatible = "samsung,s5c73m3";
>> +             reg = <0x1a>;
>> +             vddio-supply = <...>;
>> +
>> +             clock-frequency = <24000000>;
>> +             clocks = <...>;
>> +             clock-names = "mclk";
>> +
>> +             port {
>> +                     s5c73m3_1: endpoint {
>> +                             data-lanes = <1 2 3 4>;
>> +                             remote-endpoint = <&csis0_ep>;
>> +                     };
>> +             };
>> +     };
>> +
>> +     camera {
>> +             compatible = "samsung,exynos5250-fimc";
>> +             #address-cells = <1>;
>> +             #size-cells = <1>;
>> +             status = "okay";
>> +
>> +             pinctrl-names = "default";
>> +             pinctrl-0 = <&cam_port_a_clk_active>;
>> +
>> +             samsung,csis = <&csis_0>, <&csis_1>;
>> +             samsung,fimc-lite = <&fimc_lite_0>, <&fimc_lite_1>, <&fimc_lite_2>;
>> +             samsung,fimc-is = <&fimc_is>;
>> +
>> +             /* parallel camera ports */
>> +             parallel-ports {
>> +                     /* camera A input */
>> +                     port@0 {
>
> This should be port@1
>
>> +                             reg = <0>;
>
> and reg = <1>;
>
>> +                             camport_a_ep: endpoint {
>> +                                     remote-endpoint = <&s5k6aa_ep>;
>> +                                     bus-width = <8>;
>> +                                     hsync-active = <0>;
>> +                                     vsync-active = <1>;
>> +                                     pclk-sample = <1>;
>> +                             };
>> +                     };
>> +             };
>> +     };
>> +
>> +MIPI-CSIS device binding is defined in samsung-mipi-csis.txt, FIMC-LITE
>> +device binding is defined in exynos-fimc-lite.txt and FIMC-IS binding
>> +is defined in exynos5-fimc-is.txt.
>
> Otherwise looks good to me. I think we now need an Ack from the DT
> maintainers. If they are OK with the binding I could queue this whole
> series for v3.12 this week, once you resend patches #1, #2.
>


Will resend the patch series with your comments incorporated.

Regards
Arun
