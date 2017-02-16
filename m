Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32840 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932344AbdBPTUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 14:20:04 -0500
Subject: Re: [PATCH v4 01/36] [media] dt-bindings: Add bindings for i.MX media
 driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-2-git-send-email-steve_longerbeam@mentor.com>
 <1487246051.2377.41.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5349304b-1994-f207-e1bc-974999d1acfd@gmail.com>
Date: Thu, 16 Feb 2017 11:20:00 -0800
MIME-Version: 1.0
In-Reply-To: <1487246051.2377.41.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 03:54 AM, Philipp Zabel wrote:
> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
>> Add bindings documentation for the i.MX media driver.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>  Documentation/devicetree/bindings/media/imx.txt | 66 +++++++++++++++++++++++++
>>  1 file changed, 66 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
>> new file mode 100644
>> index 0000000..fd5af50
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/imx.txt
>> @@ -0,0 +1,66 @@
>> +Freescale i.MX Media Video Device
>> +=================================
>> +
>> +Video Media Controller node
>> +---------------------------
>> +
>> +This is the media controller node for video capture support. It is a
>> +virtual device that lists the camera serial interface nodes that the
>> +media device will control.
>> +
>> +Required properties:
>> +- compatible : "fsl,imx-capture-subsystem";
>> +- ports      : Should contain a list of phandles pointing to camera
>> +		sensor interface ports of IPU devices
>> +
>> +example:
>> +
>> +capture-subsystem {
>> +	compatible = "fsl,capture-subsystem";
>
> "fsl,imx-capture-subsystem"


Fixed.

Steve
