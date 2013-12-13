Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:47531 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3LMDI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 22:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <52A9D6FE.30302@samsung.com>
References: <1383650355-28838-1-git-send-email-arun.kk@samsung.com>
	<52A9D6FE.30302@samsung.com>
Date: Fri, 13 Dec 2013 08:38:27 +0530
Message-ID: <CALt3h7982XtWv_EesvVD+hOPG-7BitKS5niYwC4H+nqGUEm01A@mail.gmail.com>
Subject: Re: [PATCH v11 1/2] [media] exynos5-is: Adds DT binding documentation
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Dec 12, 2013 at 9:02 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Arun,
>
> (Adding Mark and Mauro to Cc)
>
> On 05/11/13 12:19, Arun Kumar K wrote:
>> From: Shaik Ameer Basha <shaik.ameer@samsung.com>
>>
>> The patch adds the DT binding doc for exynos5 SoC camera
>> subsystem.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  .../bindings/media/exynos5250-camera.txt           |  126 ++++++++++++++++++++
>>  1 file changed, 126 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/exynos5250-camera.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5250-camera.txt b/Documentation/devicetree/bindings/media/exynos5250-camera.txt
>> new file mode 100644
>> index 0000000..09420ba
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5250-camera.txt
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
>> +                          the clock-names property
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
>
> Was there posted a version of this patch with Mark's comments addressed:
> http://www.spinics.net/lists/devicetree/msg11550.html ? I couldn't find it.
>


I think it is missed as I also couldn't find it. I can quickly send an
updated patch
with these reviews addressed.

Regards
Arun
