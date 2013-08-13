Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:61904 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3HMIkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Aug 2013 04:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <520416D8.9050701@gmail.com>
References: <1375866242-18084-1-git-send-email-arun.kk@samsung.com>
	<1375866242-18084-2-git-send-email-arun.kk@samsung.com>
	<520416D8.9050701@gmail.com>
Date: Tue, 13 Aug 2013 14:10:39 +0530
Message-ID: <CALt3h7_AeB4jSbOP604OY5PGVAqKAVXixDQ8z2f9naN6VOqKQQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Aug 9, 2013 at 3:38 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 08/07/2013 11:03 AM, Arun Kumar K wrote:
>>
>> From: Shaik Ameer Basha<shaik.ameer@samsung.com>
>>
>> This patch adds support for media device for EXYNOS5 SoCs.
>> The current media device supports the following ips to connect
>> through the media controller framework.
>>
>> * MIPI-CSIS
>>    Support interconnection(subdev interface) between devices
>>
>> * FIMC-LITE
>>    Support capture interface from device(Sensor, MIPI-CSIS) to memory
>>    Support interconnection(subdev interface) between devices
>>
>> * FIMC-IS
>>    Camera post-processing IP having multiple sub-nodes.
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
>>    +--------+     +-----------+     +-----------+     +--------+
>>    | Sensor | -->  | MIPI-CSIS | -->  | FIMC-LITE | -->  | Memory |
>>    +--------+     +-----------+     +-----------+     +--------+
>>
>> Pipeline1
>>   +--------+      +--------+     +-----------+     +-----------+
>>   | Memory | -->   |  ISP   | -->  |    SCC    | -->  |    SCP    |
>>   +--------+      +--------+     +-----------+     +-----------+
>>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> ---
>>   .../devicetree/bindings/media/exynos5-mdev.txt     |  148 +++
>>   drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1189
>> ++++++++++++++++++++
>>   drivers/media/platform/exynos5-is/exynos5-mdev.h   |  164 +++
>>   3 files changed, 1501 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/exynos5-mdev.txt
>>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>> b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>> new file mode 100644
>> index 0000000..8b2ffb9
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>> @@ -0,0 +1,148 @@
>> +Samsung EXYNOS5 SoC Camera Subsystem
>> +------------------------------------
>> +
>> +The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
>> +represented by separate device tree nodes. Currently this includes:
>> FIMC-LITE,
>> +MIPI CSIS and FIMC-IS.
>> +
>> +The sub-subdevices are defined as child nodes of the common 'camera' node
>> which
>> +also includes common properties of the whole subsystem not really
>> specific to
>> +any single sub-device, like common camera port pins or the CAMCLK clock
>> outputs
>> +for external image sensors attached to an SoC.
>> +
>> +Common 'camera' node
>> +--------------------
>> +
>> +Required properties:
>> +
>> +- compatible   : must be "samsung,exynos5-fimc", "simple-bus"
>> +- clocks       : list of clock specifiers, corresponding to entries in
>> +                 the clock-names property;
>> +- clock-names  : must contain "sclk_bayer" entry and matching clock
>> property
>> +                  entry
>
>
> I guess "and matching clock property entry" could be removed.
>

Ok

>
>> +The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be
>> used
>> +to define a required pinctrl state named "default" and optional pinctrl
>> states:
>
>
> How about only supporting "default" pinctrl state in this initial DT
> binding/driver
> version ? The optional states could be added later, my concern is that
> except the
> camera port A, B there is also the RGB camera bay. Thus using "idle",
> "active-a",
> active-b" won't work any more. We need to find some better solution for
> that.
>

Ok will put only default state.

> Besides now when you removed the clock provider, there is not much you could
> do
> with those optional pinctrl states. Those were originally meant to be used
> in
> the clk_prepare/clk_unprepare ops. So, e.g. when sensor disables the clock
> the
> host driver sets a clock output pin into idle state, e.g. input with pull
> down.
>
> But maybe Exynos5 SoCs got improved comparing to e.g. Exynos4 so the clock
> output
> pin is put into high impedance state when the sclk_cam clock is disabled ?
> However that seems unlikely.
>
>
>> +"idle", "active-a", active-b". These optional states can be used to
>> switch the
>> +camera port pinmux at runtime. The "idle" state should configure both the
>> camera
>> +ports A and B into high impedance state, especially the CAMCLK clock
>> output
>> +should be inactive. For the "active-a" state the camera port A must be
>> activated
>> +and the port B deactivated and for the state "active-b" it should be the
>> other
>> +way around.
>> +
>> +The 'camera' node must include at least one 'fimc-lite' child node.
>
>
> This shouldn't be necessary, i.e. making the individual device nodes child
> nodes
> of the camera node. Think of GScaler which can be used either by the camera
> or
> the display/HDMI subsystem. Although csis and fimc-lite are purely camera
> specific
> I'm inclined to move them out of the camera node and couple them with this
> node
> either manually through 'compatible' values or explicitly through phandles.
>
>
>> +'parallel-ports' node
>> +---------------------
>> +
>> +This node should contain child 'port' nodes specifying active parallel
>> video
>> +input ports. It includes camera A and camera B inputs. 'reg' property in
>> the
>
>
> I suppose the RGB camera bay needs to be also listed here. It could be added
> later but might be more reasonable to add it now, e.g.
>
> 1 - parallel camport A
> 2 - parallel camport B
> 3 - serial MIPI CSI-2 port 0
> 4 - serial MIPI CSI-2 port 1
> 5 - RGB camera bay
>
> 3, 4 are already described in samsung-mipi-csis.txt.
>
>
>> +port nodes specifies data input - 0, 1 indicates input A, B respectively.
>> +
>> +Image sensor nodes
>> +------------------
>> +
>> +The sensor device nodes should be added to their control bus controller
>> (e.g.
>> +I2C0) nodes and linked to a port node in the csis or the parallel-ports
>> node,
>> +using the common video interfaces bindings, defined in
>> video-interfaces.txt.
>> +The implementation of this bindings requires clock-frequency property to
>> be
>> +present in the sensor device nodes.
>> +
>> +Example:
>> +
>> +       aliases {
>> +               fimc-lite0 =&fimc_lite_0
>> +       };
>
> [...]
>
>> +       camera {
>> +               compatible = "samsung,exynos5-fimc", "simple-bus";
>> +               #address-cells =<1>;
>> +               #size-cells =<1>;
>> +               status = "okay";
>> +
>> +               pinctrl-names = "default";
>> +               pinctrl-0 =<&cam_port_a_clk_active>;
>> +
>> +               /* parallel camera ports */
>> +               parallel-ports {
>> +                       /* camera A input */
>> +                       port@0 {
>> +                               reg =<0>;
>> +                               fimc0_ep: endpoint {
>> +                                       remote-endpoint =<&s5k6aa_ep>;
>> +                                       bus-width =<8>;
>> +                                       hsync-active =<0>;
>> +                                       vsync-active =<1>;
>> +                                       pclk-sample =<1>;
>> +                               };
>> +                       };
>> +               };
>> +
>> +               fimc_lite_0: fimc-lite@13C00000 {
>> +                       compatible = "samsung,exynos5250-fimc-lite";
>> +                       reg =<0x13C00000 0x1000>;
>> +                       interrupts =<0 126 0>;
>> +                       clocks =<&clock 129>;
>> +                       clock-names = "flite";
>> +                       status = "okay";
>> +               };
>> +
>> +               csis_0: csis@11880000 {
>> +                       compatible = "samsung,exynos4210-csis";
>> +                       reg =<0x11880000 0x1000>;
>> +                       interrupts =<0 78 0>;
>> +                       /* camera C input */
>> +                       port@3 {
>> +                               reg =<3>;
>> +                               csis0_ep: endpoint {
>> +                                       remote-endpoint =<&s5c73m3_ep>;
>> +                                       data-lanes =<1 2 3 4>;
>> +                                       samsung,csis-hs-settle =<12>;
>> +                               };
>> +                       };
>> +               };
>> +       };
>> +
>> +MIPI-CSIS device binding is defined in samsung-mipi-csis.txt and
>> FIMC-LITE
>> +device binding is defined in exynos-fimc-lite.txt.
>> diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c
>> b/drivers/media/platform/exynos5-is/exynos5-mdev.c
>> new file mode 100644
>> index 0000000..4cef69e
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
>> @@ -0,0 +1,1189 @@
>
> [...]
>
>> +/* Register FIMC, FIMC-LITE and CSIS media entities */
>> +static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
>> +                                                struct device_node
>> *parent)
>> +{
>> +       struct device_node *node;
>> +       int ret = 0;
>> +
>> +       for_each_available_child_of_node(parent, node) {
>> +               struct platform_device *pdev;
>> +               int plat_entity = -1;
>> +
>> +               pdev = of_find_device_by_node(node);
>> +               if (!pdev)
>> +                       continue;
>> +
>> +               /* If driver of any entity isn't ready try all again
>> later. */
>> +               if (!strcmp(node->name, CSIS_OF_NODE_NAME))
>> +                       plat_entity = IDX_CSIS;
>> +               else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
>> +                       plat_entity = IDX_FLITE;
>> +               else if (!strcmp(node->name, FIMC_IS_OF_NODE_NAME))
>> +                       plat_entity = IDX_FIMC_IS;
>
>
> And that needs to be replaced with something else, e.g. phandles or
> searching
> with compatible value as the key. The former will be of course less
> efficient.
> By the time I wrote similar code for Exynos4 I wasn't really aware the
> device
> node names should not have semantic meaning.
>

Ok I will use phandles.

Regards
Arun
