Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31012 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaCRLbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 07:31:36 -0400
Message-id: <53282E91.5020009@samsung.com>
Date: Tue, 18 Mar 2014 12:31:29 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH v8 3/10] Documentation: devicetree: Update Samsung FIMC DT
 binding
References: <1823087.0J3KNi6X3C@avalon>
 <1394555670-14155-1-git-send-email-s.nawrocki@samsung.com>
 <20140318100213.GC8043@e106331-lin.cambridge.arm.com>
In-reply-to: <20140318100213.GC8043@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

Thanks for your review.

On 18/03/14 11:02, Mark Rutland wrote:
> On Tue, Mar 11, 2014 at 04:34:30PM +0000, Sylwester Nawrocki wrote:
>> > This patch documents following updates of the Exynos4 SoC camera subsystem
>> > devicetree binding:
>> > 
>> >  - addition of #clock-cells and clock-output-names properties to 'camera'
>> >    node - these are now needed so the image sensor sub-devices can reference
>> >    clocks provided by the camera host interface,
>> >  - dropped a note about required clock-frequency properties at the
>> >    image sensor nodes; the sensor devices can now control their clock
>> >    explicitly through the clk API and there is no need to require this
>> >    property in the camera host interface binding.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > ---
>> > Changes since v7:
>> >  - dropped a note about clock-frequency property in sensor nodes.
>> > 
>> > Changes since v6:
>> >  - #clock-cells, clock-output-names documented as mandatory properties;
>> >  - renamed "cam_mclk_{a,b}" to "cam_{a,b}_clkout in the example dts,
>> >    this now matches changes in exynos4.dtsi further in the patch series;
>> >  - marked "samsung,camclk-out" property as deprecated.
>> > 
>> > Changes since v5:
>> >  - none.
>> > 
>> > Changes since v4:
>> >  - dropped a requirement of specific order of values in clocks/
>> >    clock-names properties (Mark) and reference to clock-names in
>> >    clock-output-names property description (Mark).
>> > ---
>> >  .../devicetree/bindings/media/samsung-fimc.txt     |   44 +++++++++++++-------
>> >  1 file changed, 29 insertions(+), 15 deletions(-)
>> > 
>> > diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> > index 96312f6..922d6f8 100644
>> > --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> > +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> > @@ -15,11 +15,21 @@ Common 'camera' node
>> > 
>> >  Required properties:
>> > 
>> > -- compatible	: must be "samsung,fimc", "simple-bus"
>
> While it was already the case, why is "samsung,fimc" also a simple bus?

IIRC the main reason was to have children automatically instantiated
in Linux, also "samsung,fimc" is a master node gathering the all related
camera subsystem memory mapped IP blocks.

> If it has any properties which are required for the correct use of the
> child nodes, it is _not_ a simple-bus.

Then this can be considered a separate issue, and could be addressed
in a separate patch ?

>> > -- clocks	: list of clock specifiers, corresponding to entries in
>> > -		  the clock-names property;
>> > -- clock-names	: must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
>> > -		  "pxl_async1" entries, matching entries in the clocks property.
>> > +- compatible: must be "samsung,fimc", "simple-bus"
>> > +- clocks: list of clock specifiers, corresponding to entries in
>> > +  the clock-names property;
>> > +- clock-names : must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
>> > +  "pxl_async1" entries, matching entries in the clocks property.
>> > +
>> > +- #clock-cells: from the common clock bindings (../clock/clock-bindings.txt),
>> > +  must be 1. A clock provider is associated with the 'camera' node and it should
>> > +  be referenced by external sensors that use clocks provided by the SoC on
>> > +  CAM_*_CLKOUT pins. The clock specifier cell stores an index of a clock.
>> > +  The indices are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
>> > +
>> > +- clock-output-names: from the common clock bindings, should contain names of
>> > +  clocks registered by the camera subsystem corresponding to CAM_A_CLKOUT,
>> > +  CAM_B_CLKOUT output clocks respectively.
>
> And if we're adding more stuff required by child nodes it's definitely
> not a simple-bus.
> 
> Get rid of simple-bus. Get the driver for "samsung,fimc" to probe its
> children once it has set up.
> 
> Apologies for the late reply, and sorry to have to be negative on this.

While I agree with you that the "simple-bus" might not be a best idea,
I can't see how your suggestion could be now implemented in Linux, since
AFAIK there is no API like of_platform_unpopulate(), so device objects
can be removed upon the driver module removal.

--
Regards,
Sylwester
