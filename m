Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CBAgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 19:36:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linaro-mm-sig@lists.linaro.org
Cc: jesse.barker@arm.com, tom.gall@linaro.org, tomi.valkeinen@ti.com,
	linus.walleij@linaro.org, Keith Packard <keithp@keithp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Tomasz Figa <t.figa@samsung.com>,
	Alison Chaiken <alison_chaiken@mentor.com>
Subject: Summary of CDF BoF @ELC 2013
Date: Sat, 02 Mar 2013 01:37:10 +0100
Message-ID: <8790741.5tF3ronmWJ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's a summary of the CDF BoF that took place at the ELC 2013.

I'd like to start by thanking all the participants who provided valuable 
feedback (and those who didn't, but who now know a bit more about CDF and 
will, I have no doubt about that, contribute in the future :-)). Thank you 
also to Linus Walleij and Jesse Barker for taking notes during the meeting 
while I was presenting. And obviously, thank you to Jesse Barker for 
organizing the BoF.

I've tried to be as accurate as possible in this summary, but I might have 
made mistakes. If you have attended the meeting, please point out any issue, 
inconsistency, or just points I might have forgotten.

----

As not all attendees were familiar with CDF I started by briefly introducing 
the problems that prompted me to start working on CDF.

CDF started as GPF, the Generic Panel Framework. While working on DT support 
for a display controller driver I realized that panel control code was located 
in board file. Moving the code somewhere in drivers/ was thus a prerequisite, 
but it turned out that no framework existed in the kernel to support that 
tasks. Several major display controller drivers (TI DSS and Samsung Exynos to 
name a few) had a platform-specific panel driver framework, but the resulting 
panel drivers wouldn't be reusable across different display controllers. A 
need for a new framework became pretty evident to me.

After drafting an initial proposal and discussing it with several people 
online and offline (in Helsinki with Tomi Valkeinen from TI, in Copenhagen at 
Linaro Connect with Marcus Lorentzon from ST-Ericsson, and in Brussels during 
a BoF at the FOSDEM) the need to support encoders in addition to panels 
quickly arose, and GPF turned into CDF.

I then pursued with an overview of the latest CDF code and its key concepts. 
While I was expecting this to be a short overview followed by more in-depth 
discussions, it turned out to support our discussions for the whole 2 hours 
meeting.

The latest available version at the time of the BoF (posted to the linaro-mm-
sig mailing list in reply to the BoF's annoucement) was the "non-quite-v3" 
version. It incorporated feedback received on v2 but hadn't been properly 
tested yet.

The basic CDF building block is called a display entity, modeled as an 
instance of struct display_entity. They have sink ports through which they 
receive video data and/or source ports through which they transmit video data. 
Entities are chained via their ports to create a display pipeline.

>From the outside world entities are interfaced through two sets of abstract 
operations they must provide:

- Control operations are called from "upper layers" (usually to implement 
userspace requests) to get and set entity parameters (such as the physical 
size, video modes, operation states, bus parameters, ...). Those operations 
are implemented at the entity level.

Google asked how partial updates were handled, I answered  they're not handled 
yet (this is a key concept behind the CDF RFCs: while I try to make sure all 
devices can be supported, I first concentrate on hardware features required 
for the devices I work on). Linus Walleij mentioned he thought that partial 
updates were becoming out of fashion, but larger display sizes might keep them 
useful in the future.

- Video operations control video streams. They're implemented by entities on 
their source ports, and are called in the upstream (from a video pipeline 
point of view) direction. A panel will call video operations of the entity it 
gets its video stream from (this could be an HDMI transmitter, the display 
controller directly, ...) to control the video stream it receives.

Video operations are split in a set of common operations and sets of display 
bus specific operations (for DPI, DBI, DSI, ...). Some discussion around ops 
that might be needed in some cases but not others indicate that the ops 
structures are not quite finished for all bus types (and/or that some ops 
might be considered for "promotion" to common). In particular the current DSI 
implementation is copied from a proposal posted by Tomasz Figa from Samsung. 
As I have no DSI hardware to test it on I have kept it as-is.

Jesse Barker pointed out that to make this fly we willl need to get CDF into a 
number of implementations, in particular the Samsung Exynos SoCs (needing 
DSI). Several efforts are ongoing:

- Marcus Lorentzon (ST Ericsson, Linaro) is working on porting ST Ericsson 
code to CDF, and in particular on the DSI interface.

- Tomasz Figa (Samsung) has worked on porting the Exynos display controller 
driver to CDF and provided a DSI implementation.

- Tomi Valkeinen (TI) is working on porting the TI DSS driver to CDF (or 
rather his own version of CDF as a first step, to avoid depending on an ever-
moving target right now) independently from Linaro.

- Alison Chaiken (Mentor Embedded Software) mentioned that Pengutronix is 
working on panels support for the Freescale i.MX family.

- Linaro can probably also help extending the test coverage to various 
platforms from its member companies.

- Finally, I'm working on CDF support for two display controllers found in 
Renesas SoCs. One of them support DBI and DPI, the other supports DPI only. 
However, I can't easily test DBI support, as I don't have access to the 
necessary hardware.


I explained at that point that there is currently no clear agreement on a bus 
and operations model. The initial CDF proposal created a Linux busses for DBI 
and DSI (similar to I2C and SPI busses), with access to the control bus 
implemented through those Linux busses, and access to the video bus 
implemented through video operations on display entities. Tomi Valkeinen then 
advocated for getting rid of the DBI and DSI Linux busses and implementing 
access to both control and video through the display entity operations, while 
Marcus Lorentzon wanted to implement all those operations at the Linux bus 
level instead. The best way to arbitrate this will probably to work on several 
implementations and find out which one works better.

SONY Mobile currently supports DSI auto-probing, with plug-n-play detection of 
DSI panels. The panel ID is first retrieved, and the correct panel driver is 
then loaded. We will likely need to support a similar model. Another option 
would be to write a single panel-dcs driver to support all DSI panels that 
conform with the DSI and DCS standards (although we will very likely need 
panel-specific quirks in that case). The two options could also coexist.

We then moved to how display entities should be handled by KMS drivers and 
mapped to KMS objects. The KMS model hardcodes the following fixed pipeline

	CRTC -> encoder -> connector

The CRTC is controlled by the display controller driver, and panels can be 
mapped to KMS connector objects. What goes in-between is more of a gray area, 
as hardware pipeline can have several encoders chained together.

I've presented one possible control flow that could solution the problem by 
grouping multiple objects into an abstract entity. The right-most entity would 
be a standalone entity, and every encoder but the left-most one in the chain 
would hide the entities connected at their output. This results in a "russian 
dolls" model, where encoders forward control operations to the entities they 
embed, and forward video operations to the entity at their sink side.

This can quickly become very complex, especially when locking and reference 
counting are added to the model. Furthermore, this solution could only handle 
linear pipelines, which will likely become a severe limitation in the future, 
especially on embedded devices (for instance splitting a video stream between 
two panels at the encoder level is a common use case, or driving a two-inputs 
panel from two CRTCs).

Google asked whether this model tries to address both panels and 
VGA(/HDMI/...) outputs. From what I've seen so far the only limits come from 
the hardware engineers (often^H^H^H^H^Hsometimes troubled) minds, all kinds of 
data streams may appear in practice. As most systems will have one CRTS, one 
encoder and one panel (or connector), we should probably try to keep the model 
simple to start with with 1:1 mappings between the KMS CRTC/encoder/connector 
model and the CDF model. If we try to solve every possible problem right now 
the complexity will explode and we won't be able to handle it. Getting a 
simple solution upstream now and refactoring it later (there is no userspace 
API involved, so no backward compatibility issue) might be the right answer. I 
have no strong feeling about it, but I certainly want something I can get 
upstream in a reasonable time frame.

Keith Packard bluntly (and totally rightfully) whether CDF is not just 
duplicating part of the KMS API, and whether we shouldn't instead extend the 
in-kernel KMS model to handle multiple encoders.

One reason that drove the creation of CDF outside of KMS was to support 
sharing a single driver between multiple subsystems. For instance an HDMI 
encoder could be connected to the output of a display controller handled by a 
KMS driver on one board, and to the output of a video processor handled by a 
V4L2 driver on another board. A panel could also be connected to a display 
controller handled by a KMS driver on one board, and to a display controller 
handled by an FBDEV driver on another board. Having a single driver for those 
encoders or panels is one of the goals of CDF.

After publishing the first CDF RFC I realized there was a global consensus in 
the kernel display community to deprecate FBDEV at some point. Sharing panel 
drivers between KMS and FBDEV then became a "nice to have, but not important" 
feature. As V4L2 doesn't handle panels (and shouldn't be extended to do so) 
only encoders drivers would need to be shared, between KMS and V4L2.

It's important to note here that we don't need to share a given encoder 
between two subsystems at runtime. On a given board the encoder will need to 
be controlled by KMS or V4L2, but never both at the same time. In the CDF 
context driver sharing refers to the ability to control a given driver from 
either the KMS or V4L2 subsystem.

The discussion then moved to why V4L2 drivers for devices connected to an 
encoder couldn't be moved to KMS. All display devices should be handled by 
KMS, but we still have use cases where V4L2 need to handle video outputs. For 
instance a system with the following pipeline

	HDMI con. -> HDMI RX -> Processing Engine -> HDMI TX -> HDMI con.

doesn't involve memory buffers in the processing pipeline. This can't be 
handled by KMS, as KMS cannot reporesent a video pipeline without memory in-
between the receiving side and the display side. Hans Verkuil also mentioned 
that for certain applications one prefers to center the API around frames, and 
that V4L2 is ideal for instance for video conferencing/telephony.

Keith Packard thought we should just extend KMS to handle the V4L2 use cases. 
V4L2 would then (somehow) plug its infrastructure into KMS. This topic has 
already been discussed in the past, and I agree that extending the KMS model 
to support "live sources" for CRTCs will be needed in the near future. This 
could be the basis of other KMS enhancements to support more complex 
pipelines. Making KMS and V4L2 cooperate is also desirable on the display side 
to write the output of the CRTC back to memory. KMS has no write-back feature 
in the API, V4L2 could come to the rescue there.

With this kind of extension it might be possible to handle the display part of 
memory-less pipelines in KMS, although that might be quite a challenge. There 
was no clear consensus on whether this was desirable.

Furthermore, only two HDMI encoders currently need to be shared (both are only 
supported out-of-tree at the moment). As we don't expect more than a handful 
of such use cases in the near future, it might not be worth the hasle to 
create a complete infrastructure to handle a use case that might disappear if 
we later move all the display-side drivers to KMS.

Another solution mentioned by Hans Verkuil would be to create helper functions 
to translate V4L2 calls to KMS calls (to be clear, this only covers in-kernel 
calls to encoders).

There was no clear consensus on this topic.

We then moved on to the hot-plug (and hot-unplug) issues following a question 
from Google. Hot-plug is currently not supported. We would need to add hot-
plugging notifiers and possibly a couple of other operations. However, the 
video common operations structure has bind/unbind operations, that can serve 
as a basis.

The hard part in hot-plugging support is actually hot-unplugging, as we need 
to ensure that devices don't disappear all of a sudden while still in use. 
This was a design goal of CDF from the start, and any issue there will need to 
be resolved. Panels shouldn't be handled differently than HDMI connectors, CDF 
will provide a common hot-plugging model.

Keith Packard then explained that DRM and KMS will likely be split in the 
future. The main link between the DRM and KMS APIs is GEM objects. With the 
recent addition of dmabuf to the Linux kernel the DRM and KMS APIs could be 
split and use dmabuf to share buffers. DRM and KMS would then be exposed on 
two separate device nodes. It would be a good idea to revisit the whole 
KMS/V4L2 unification discussion when DRM and KMS will be split.

We briefly touched the subject of namespaces, and whether CDF should use the 
KMS namespace (drm_*). There is some resistance on the V4L2 side on having CDF 
structures be KMS objects. 

It was then time to wrap up the meeting, and I asked the audience one final 
question: should we shoehorn complex pipelines into the KMS three-stages 
model, or should we extend the KMS model? That was unfortunately answered by 
silence, showing that more thinking is needed.

A couple more minutes of offline discussions briefly touched the topics of GPU 
driver reverse engineering and whether we could, after the KMS/DRM split, set 
a kernel-side standard for embedded GPU drivers. As interesting as this topic 
is, CDF will not solve that problem :-)

-- 
Regards,

Laurent Pinchart

