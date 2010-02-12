Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36433 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0BLBWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 20:22:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Maupin, Chase" <chase.maupin@ti.com>
Subject: Re: Requested feedback on V4L2 driver design
Date: Fri, 12 Feb 2010 02:22:35 +0100
Cc: Hans Verkuil <hans.verkuil@tandberg.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
In-Reply-To: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002120222.38816.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chase,

On Monday 08 February 2010 16:08:37 Maupin, Chase wrote:
> All,
> 
> Texas Instruments (TI) is working on the design for the V4L2 capture and
> display drivers for our next generation system-on-chip (SoC) processor and
> would like to solicit your feedback.

Thank you very much for requesting feedback on the system design. I personally 
appreciate this, and I'm pretty sure that the feeling is shared by most of the 
Linux kernel developers.

> If you have additional questions or need more information please feel free
> to contact us (we have setup a mailing list at
> vpss_driver_design@list.ti.com) so we can answer them.

I'll answer here as the instructions provided in the wiki to subscribe to the 
vpss_driver_design mailing list are incorrect (http://list.ti.com/ isn't 
accessible, the name has no A record associated to it). I've CC'ed the list in 
case subscription wouldn't be required to post.

1. Multi-core design
--------------------

OMAP3 was already a dual-core system, OMAP4 (I assume all this is about the 
OMAP4 processors family) seems to push the concept one step further.

With its heterogeneous multi-core design (ARM master CPU and slave DSPs), the 
OMAP architecture delivers high performances at the cost of higher development 
time and effort as users need to write software for completely different 
cores, usually using different toolchains. This is in my opinion a good (or at 
least acceptable) trade-off between CPU power, development time and power 
consumption (DSPs being more efficient at signal processing at the cost of a 
higher development complexity).

I'm a bit puzzled, however, by how the VPSS MCU will help improving the 
situation compared to the OMAP3 design. The VPSS MCU will provide an API that 
will expose a fixed subset of the hardware capabilities. This is only a guess, 
but I suppose the firmware will be fairly generic, and that TI will provide 
customized versions to big customers tailored for their needs and use cases. 
The "official" kernel drivers will then need to be changed, and those changes 
will have no chance to be accepted in the mainline kernel. This will lead to 
forks and fragmentation of the developers base among the big players in the 
embedded markets. What will be the compensation for that ? How will the VPSS 
MCU provide higher performances than the OMAP3 model ?

2. VPSS firmware and API
------------------------

The wiki doesn't state under which license the VPSS MCU firmware will be 
released, but I suppose it won't be open sourced. The VPSS API, which seems 
from the information provided in the wiki to mimic the V4L2 API at least for 
video capture and output, will thus be controlled by TI and pretty much set 
into stone. This means future extensions to the V4L2 API that will provide 
more control over the devices to userspace applications will be stuck with 
access to a limited subset of the hardware capabilities, and users will not be 
able to use the full potential of the system.

This goes in the opposite direction of what the Linux media community is 
trying to do today. For the past 6 months now we have been working on 
additions to the V4L2 subsystem to create a complete media framework, targeted 
at both desktop and embedded use cases. The new APIs that we are developing 
will let userspace applications discover the internal topology of the hardware 
and control every parameter in the video pipeline(s). This include dynamic 
reconfiguration of the pipeline(s),  completely under control of userspace. 
With a VPSS API that mimics today's V4L2 API, the OMAP4 video pipeline will 
look from a userspace perspective as an old-school V4L2 device, a single black 
box with a few controls to accommodate common use cases.

Regardless of the firmware license, we need a way to control hardware without 
any limitation from the ARM processor. This includes explicit configuration of 
the pipeline, and access to all configuration parameters of all hardware 
processing blocks.

3. VPSS API usage from kernel space
-----------------------------------

The wiki mentions that Linux kernel drivers will have access to functions that 
convert "standard kernel data structures" to VPSS data structures as required 
by the VPSS firmware. I don't think that's a good idea. Please let kernel 
drivers do the conversion themselves. Linux kernel drivers know about their 
data structures better than the VPSS library/middleware/layer/whatever will 
do. Instead of providing such conversion functions, I would like to see the 
VPSS data structures properly documented so that kernel driver developers will 
know what information the VPSS MCU expects. Filling the VPSS data structures 
from "standard kernel data structures" should be left to individual drivers 
and/or subsystems.

As explained above, I'm really concerned about the following usage example:

"Driver calls VPSS set_format function and passes the VPSS format data 
structure. The VPSS set_format function will then:
 - Create a message structure for sending over the Notify IPC 
 - Set the command element with the set format command value 
 - Set the arguements element to the address of the VPSS format data structure 
 - Call the syslink Notify kernel API and send the address of the message 
structure to the VPSS"

This means the VPSS MCU will expose a single black box to the host, making it 
impossible to use the full capabilities of the hardware with future V4L2 
extensions. Those extensions are developed for a reason. V4L2 simply doesn't 
scale in the light of future (and even today's) embedded hardware. If the VPSS 
API mimics V4L2 it will suffer from the same problem.

One possible solution would be to open-source the VPSS MCU firmware, allowing 
the Linux community to expose capabilities needed by future V4L2 extensions 
through the VPSS API.

4. VPSS API usage from userspace
--------------------------------

I have no specific comment about the userspace API usage, but I would like to 
know how you plan to arbitrate access to the hardware from both kernelspace 
(through a V4L2 driver) and userspace. Will there be a way for kernel drivers 
to take ownership of specific hardware parts and disallow userspace 
applications from issuing any message to those parts ? The design must be 
carefully reviewed to spot possible race conditions and even security issues.

5. Syslink
----------

I still need to review the syslink code. As stated by Hans Verkuil, from a 
quick look at the source tree the syslink module looks over-engineered. To 
communicate with the VPSS MCU all that seems to be needed is a mailbox-like 
interface.

Furthermore, the mailbox API should probably not be OMAP4-specific. Isn't 
there already a mailbox API in Linux ? If not I think one should be developed 
first, and then syslink should be built on top of it. The best way to see a 
driver being rejected when submitted to mainline is to write a huge pile of 
code and then push it in one go.



As a conclusion, I believe that the best chance to get drivers into mainline 
and to get developers excited about the product (both are related in my 
experience) is to be as open as possible and play by the rules of the Linux 
kernel community. This means that:

- Big subsystems such as syslink should be broken down to small pieces, and 
every piece, especially the low-level ones, must be carefully designed with 
the whole Linux kernel in mind, not only the OMAP4 platform. APIs should be 
made generic when possible.

- The VPSS MCU firmware should be properly documented, developed in the open 
and under an open-source license.

Those two steps should be performed in tight cooperation with the Linux kernel 
community.

-- 
Best regards,

Laurent Pinchart
