Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43655 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145Ab0BZPfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 10:35:31 -0500
From: "Maupin, Chase" <chase.maupin@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hans.verkuil@tandberg.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Kamoolkar, Mugdha" <mugdha@ti.com>
Date: Fri, 26 Feb 2010 09:35:10 -0600
Subject: RE: Requested feedback on V4L2 driver design
Message-ID: <131E5DFBE7373E4C8D813795A6AA7F0802E84A29C0@dlee06.ent.ti.com>
References: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
 <201002120222.38816.laurent.pinchart@ideasonboard.com>
 <131E5DFBE7373E4C8D813795A6AA7F0802C4EC925C@dlee06.ent.ti.com>
 <201002260131.49065.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201002260131.49065.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Responses inline

Puru,

There is a question for you below.  Can you look at it and provide an answer?

Sincerely,
Chase Maupin
Software Applications
Catalog DSP Products
e-mail: chase.maupin@ti.com
phone: (281) 274-3285

For support:
Forums - http://community.ti.com/forums/
Wiki - http://wiki.davincidsp.com/

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, February 25, 2010 6:32 PM
> To: Maupin, Chase
> Cc: Hans Verkuil; sakari.ailus@maxwell.research.nokia.com;
> mchehab@infradead.org; vpss_driver_design@list.ti.com - This list is to
> discuss the VPSS driver design (May contain non-TIers); linux-
> media@vger.kernel.org; Kamoolkar, Mugdha
> Subject: Re: Requested feedback on V4L2 driver design
>
> Hi Chase,
>
> On Friday 12 February 2010 17:46:55 Maupin, Chase wrote:
> > Laurent,
> >
> > First let me thank you for taking time to review this.
>
> You're welcome.
>
> [snip]
>
> > > -----Original Message-----
> > > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > > Sent: Thursday, February 11, 2010 7:23 PM
> > >
> > > On Monday 08 February 2010 16:08:37 Maupin, Chase wrote:
>
> [snip]
>
> > > > If you have additional questions or need more information please
> feel
> > > > free to contact us (we have setup a mailing list at
> > > > vpss_driver_design@list.ti.com) so we can answer them.
> > >
> > > I'll answer here as the instructions provided in the wiki to subscribe
> to
> > > the vpss_driver_design mailing list are incorrect (http://list.ti.com/
> > > isn't accessible, the name has no A record associated to it). I've
> CC'ed
> > > the list in case subscription wouldn't be required to post.
> >
> > The page for subscribing to the list requires a my.TI login which you
> can
> > setup at
> >
> https://myportal.ti.com/portal/dt?provider=TIPassLoginSingleContainer&lt=m
> > yti&j5=2&j3=1&goto=https%3A%2F%2Fmy.ti.com%3A443%2Fcgi-
> bin%2Fhome.pl%3FDCMP
> > %3DTIHeaderTracking%26HQS%3DOther%2BOT%2Bhdr_my_ti.
> > However, your reply to the list should be fine without subscribing.
>
> Thanks for the information, but http://list.ti.com/ still can't be
> accessed.
> The host list.ti.com has no A record, an HTTP connection can't thus be
> established.

I'm not sure what is going on here.  Let me file a ticket with our IT group and see if they can fix the problem.

>
> > > 1. Multi-core design
> > > --------------------
> > >
> > > OMAP3 was already a dual-core system, OMAP4 (I assume all this is
> about
> > > the OMAP4 processors family) seems to push the concept one step
> further.
> > >
> > > With its heterogeneous multi-core design (ARM master CPU and slave
> DSPs),
> > > the OMAP architecture delivers high performances at the cost of higher
> > > development time and effort as users need to write software for
> completely
> > > different cores, usually using different toolchains. This is in my
> opinion
> > > a good (or at least acceptable) trade-off between CPU power,
> development
> > > time and power consumption (DSPs being more efficient at signal
> processing
> > > at the cost of a higher development complexity).
> > >
> > > I'm a bit puzzled, however, by how the VPSS MCU will help improving
> the
> > > situation compared to the OMAP3 design. The VPSS MCU will provide an
> API
> > > that will expose a fixed subset of the hardware capabilities. This is
> only
> > > a guess, but I suppose the firmware will be fairly generic, and that
> TI
> > > will provide customized versions to big customers tailored for their
> needs
> > > and use cases. The "official" kernel drivers will then need to be
> changed,
> > > and those changes will have no chance to be accepted in the mainline
> > > kernel. This will lead to forks and fragmentation of the developers
> base
> > > among the big players in the embedded markets. What will be the
> > > compensation for that ? How will the VPSS MCU provide higher
> performances
> > > than the OMAP3 model ?
> >
> > The firmware on the VPSS MCU will be able to configure/control all of
> the
> > functionality that the VPSS MCU has and will be the same for all
> > customers. The only part that may change is the proxy driver of the
> > firmware. The proxy driver is the piece that will be responsible for
> > taking the commands from the driver and telling the firmware to execute
> > the operation.
>
> As the proxy is the "tip of the firmware iceberg", it will be all the
> Linux
> driver will care about. Whether the firmware "backend" is able to
> configure
> and control all of the functionality that the VPSS MCU offers is then
> irrelevant, as the Linux driver will have no way to access that backend
> directly. Is my understanding correct ?

As you saw in my follow-up e-mail the proxy will support all the VPSS APIs so my statement was misleading.

>
> > The initial version of the proxy will support all the standard V4L2
> > operations.  As new operations (such as on the fly video scaling) are
> added
> > to the V4L2 API the firmware may require an update to the proxy driver
> to
> > handle these requests, but the underlying code will remain the same.
>
> Different proxy versions will need different version of the Linux driver.
> That's where fragmentation of the developers base come into play, and
> that's
> the part that worries me.

There should only be one proxy version.

>
> > For customers who wish to use features of the VPSS that are not
> supported
> > by the current V4L2 APIs there are OpenMax components being developed
> that
> > can also talk to the VPSS and support the full set of features of the
> > VPSS.  These components allow for additional use cases such as
> > transferring data directly from other processing blocks such as the DSP
> to
> > the VPSS without ever returning to the host processor (tunneling).
> > However, the OpenMax API does not integrate with most existing software
> > such as applications that use V4L2 drivers for video capture and display.
>
> So the firmware "backend" will expose all its features through OpenMax,
> and
> the proxy will expose a V4L2-like API based on the firmware backend ? In
> that
> case why do we need a proxy at all, why can't the Linux driver access the
> firmware "backend" directly and configure it the way it sees fit ?

The firmware backend will expose all its features through the VPSS APIs.  The OpenMax components will call to proxies running on the VPSS to translate the OpenMax calls to VPSS calls much like the proxy for the V4L2 driver will.  Basically OpenMax is another way to access the VPSS APIs from a user application but can be ignored when considering Linux drivers.

>
> My understanding is that both the backend (for OpenMax) and the proxy will
> be
> accessed through the notify API. Is that correct ?

I believe on the lowest level they will both rely on Notify for sending events.

>
> > What this means is that we will not be creating a bunch of one-off
> drivers
> > for customers who want to use features that are not part of the V4L2
> APIs.
> > Instead those customers will be able to use the OpenMax components.  The
> > Linux V4L2 drivers will focus on enabling customers who are using the
> > standard V4L2 functionalities.  As the V4L2 API is expanded the only
> > changes that would be required would be to the V4L2 driver to implement
> > the new V4L2 APIs and potentially to the proxy driver on the VPSS
> firmware
> > to handle interpreting the new commands.
>
> If the first VPSS proxy version mimics the V4L2 API, changes will
> definitely
> be required to the proxy driver to handle the V4L2 enhancements. This is
> where
> an open-source version of the VPSS firmware could really help, allowing
> modifications to the firmware when needed by the Linux driver.

The VPSS proxy is not mimicking V4L2 APIs.  It is instead exposing all the VPSS APIs to the host CPU.  It would be the responsibility of the V4L2 driver to handle the V4L2 APIs and interact with the VPSS proxy to execute the requested operation using the VPSS API.

>
> > > 2. VPSS firmware and API
> > > ------------------------
> > >
> > > The wiki doesn't state under which license the VPSS MCU firmware will
> be
> > > released, but I suppose it won't be open sourced. The VPSS API, which
> > > seems from the information provided in the wiki to mimic the V4L2 API
> at
> > > least for video capture and output, will thus be controlled by TI and
> > > pretty much set into stone. This means future extensions to the V4L2
> API
> > > that will provide more control over the devices to userspace
> applications
> > > will be stuck with access to a limited subset of the hardware
> > > capabilities, and users will not be able to use the full potential of
> the
> > > system.
> >
> > I'll let one of the engineers from the VPSS firmware team comment on the
> > license here.  As of now my understanding is that the firmware will be
> > binary only.  The VPSS API will define a full set of capabilities, but
> > which APIs will be handled by the proxy driver will be initially limited
> > to the existing V4L2 features.  Thus while you could add new VPSS API
> > calls to the V4L2 driver the proxy on the VPSS MCU may not know how to
> > handle these calls.  As we go forward we will add new calls to the proxy
> > driver.  I'll let the VPSS firmware team comment more here but this is
> > good feedback on the need to at least let people extend the proxy driver
> > on the VPSS to handle future extensions.
>
> I think letting developers modify at least the proxy driver would be a
> very
> good move. It would then be much easier to keep the proxy and the Linux
> driver
> in sync.

Again, we'll look into how this could be enabled.

>
> > > This goes in the opposite direction of what the Linux media community
> is
> > > trying to do today. For the past 6 months now we have been working on
> > > additions to the V4L2 subsystem to create a complete media framework,
> > > targeted at both desktop and embedded use cases. The new APIs that we
> are
> > > developing will let userspace applications discover the internal
> topology
> > > of the hardware and control every parameter in the video pipeline(s).
> This
> > > include dynamic reconfiguration of the pipeline(s),  completely under
> > > control of userspace. With a VPSS API that mimics today's V4L2 API,
> the
> > > OMAP4 video pipeline will look from a userspace perspective as an old-
> > > school V4L2 device, a single black box with a few controls to
> accommodate
> > > common use cases.
> >
> > Again, like I stated above the VPSS API will be capable of exposing all
> of
> > the functionality of the VPSS hardware.  The limitation comes with the
> > proxy driver and what commands it interprets.  This will need to be
> > expanded as new features are added to the Linux kernel.  Basically the
> > VPSS API is full featured but the portions of it that are exposed to
> Linux
> > are initially limited to the current V4L2 APIs with plans to expand
> going
> > forward.  Your feedback indicates that we need to find a way that Linux
> > developers can expand which APIs are exposed to Linux themselves an not
> > need to rely on TI to do so.
>
> There's something I don't get. You mention that the VPSS API will be full-
> featured, but that only portions of it are exposed to Linux. Isn't it
> contradictory ? An API being an Application Programming Interface, all of
> an
> API is exposed by definition. What's not exposed is not part of the API,
> but
> is an internal implementation detail.

My previous comment was wrong.

>
> Can you clarify what you mean by "VPSS API" ? If that's a full-featured
> API
> that can be accessed by the master ARM CPU, why do we need a proxy driver
> and
> a limited proxy API at all ?
>
> > > Regardless of the firmware license, we need a way to control hardware
> > > without any limitation from the ARM processor. This includes explicit
> > > configuration of the pipeline, and access to all configuration
> parameters
> > > of all hardware processing blocks.
> > >
> > > 3. VPSS API usage from kernel space
> > > -----------------------------------
> > >
> > > The wiki mentions that Linux kernel drivers will have access to
> functions
> > > that convert "standard kernel data structures" to VPSS data structures
> as
> > > required by the VPSS firmware. I don't think that's a good idea.
> Please
> > > let kernel drivers do the conversion themselves. Linux kernel drivers
> know
> > > about their data structures better than the VPSS
> > > library/middleware/layer/whatever will do. Instead of providing such
> > > conversion functions, I would like to see the VPSS data structures
> > > properly documented so that kernel driver developers will know what
> > > information the VPSS MCU expects. Filling the VPSS data structures
> > > from "standard kernel data structures" should be left to individual
> > > drivers and/or subsystems.
> >
> > Agreed.  What I was trying to convey here is that we will have functions
> in
> > the Linux kernel drivers that will convert the kernel data structures to
> > VPSS data structures.  These functions will be part of the drivers.
>
> Ok. There was a slight misunderstanding. Thanks for the clarification.
>
> > The intent was that if a V4L2 capture and display driver both take in
> the
> > same kind of data structure (like a buffer descriptor) that they could
> share
> > the function that converts that to a VPSS data structure.  In the end it
> > is still up to each driver to process the input it is given and package
> it
> > appropriately for sending to the VPSS.  The VPSS data structures will be
> > properly documented and will not be hidden from kernel developers.
>
> Thanks.
>
> > > As explained above, I'm really concerned about the following usage
> > > example:
> > >
> > > "Driver calls VPSS set_format function and passes the VPSS format data
> > >
> > > structure. The VPSS set_format function will then:
> > >  - Create a message structure for sending over the Notify IPC
> > >  - Set the command element with the set format command value
> > >  - Set the arguements element to the address of the VPSS format data
> > > structure
> > >  - Call the syslink Notify kernel API and send the address of the
> message
> > > structure to the VPSS"
> > >
> > > This means the VPSS MCU will expose a single black box to the host,
> making
> > > it impossible to use the full capabilities of the hardware with future
> > > V4L2 extensions. Those extensions are developed for a reason. V4L2
> simply
> > > doesn't scale in the light of future (and even today's) embedded
> hardware.
> > > If the VPSS API mimics V4L2 it will suffer from the same problem.
> >
> > I think I addressed this above in stating that the VPSS API is fully
> > featured.  During the initial development we will only expose a subset
> of
> > the VPSS API as needed by the existing V4L2 API.  The list of VPSS APIs
> > that are exposed will grow over time and we need to work out if there is
> a
> > way to enable kernel developers to do this without relying on TI.
>
> What do you mean by "expose a subset of the VPSS API" ? I suppose that the
> VPSS API is basically a set of messages that can be exchanged between the
> master CPU and the VPSS, along with memory layout of data structures. Do
> you
> mean that only a subset of those messages and structures will be
> documented at
> first ? If they're all documented, I don't get what you mean by "expose a
> subset of the VPSS API".
>
> > > One possible solution would be to open-source the VPSS MCU firmware,
> > > allowing the Linux community to expose capabilities needed by future
> V4L2
> > > extensions through the VPSS API.
> >
> > Agreed.
> >
> > > 4. VPSS API usage from userspace
> > > --------------------------------
> > >
> > > I have no specific comment about the userspace API usage, but I would
> > > like to know how you plan to arbitrate access to the hardware from
> both
> > > kernelspace (through a V4L2 driver) and userspace. Will there be a way
> for
> > > kernel drivers to take ownership of specific hardware parts and
> disallow
> > > userspace applications from issuing any message to those parts ? The
> > > design must be carefully reviewed to spot possible race conditions and
> > > even security issues.
> >
> > The VPSS firmware does the hardware arbitration.  If the kernel driver
> > already has a video plane open then a user space application would not
> be
> > able to open the same video plane.
>
> Ok, so there's some kind of locking. I suppose that loading the Linux VPSS
> "ISP" driver will be enough to take ownership of the ISP, forbidding
> userspace
> applications to use it directly (otherwise the kernel driver will not like
> the
> ISP being reconfigured by userspace behind its back, and that could lead
> to a
> crash in kernel space).

Yes, the firmware does all resource management.  If the kernel driver already has a channel open and is using it when a user space application requests it then the user space application will get an error indicating the resource is already in use.

>
> How will the locking be handled ? I suppose "opening a plane" and "closing
> a
> plane" will just be a matter of sending one (or several) messages to the
> VPSS.
> In that case what would prevent a userspace application from sending a
> direct
> message to close a plane that a driver would have opened ? Will the
> firmware
> be able to identify if a close message comes from the same source as a
> previous open message, without any risk of identify spoofing ?

That is a good question.  Let me have one of the firmware guys answer this.  I too am assuming that some other application can't issue a close on a channel if they weren't the one to open it.  Puru, can you answer this?

>
> > > 5. Syslink
> > > ----------
> > >
> > > I still need to review the syslink code. As stated by Hans Verkuil,
> from
> > > a quick look at the source tree the syslink module looks over-
> engineered.
> > > To communicate with the VPSS MCU all that seems to be needed is a
> mailbox-
> > > like interface.
> > >
> > > Furthermore, the mailbox API should probably not be OMAP4-specific.
> Isn't
> > > there already a mailbox API in Linux ? If not I think one should be
> > > developed first, and then syslink should be built on top of it. The
> best
> > > way to see a driver being rejected when submitted to mainline is to
> write
> > > a huge pile of code and then push it in one go.
> >
> > I'll need to let the syslink team comment on this.  I know they are
> > reworking some of the syslink code such that most of the advanced usage
> is
> > done from user space and only the basic message passing is done in the
> > kernel.
>
> That's very good news.
>
> > I'm not sure if they have been working on a generic mailbox interface.
> The
> > syslink Notify module being part of the Linux kernel is a requirement
> for us
> > and they are actively working on getting it into the kernel.
> >
> > Mugdha, can someone from the syslink team comment here?
> >
> > > As a conclusion, I believe that the best chance to get drivers into
> > > mainline and to get developers excited about the product (both are
> related
> > > in my experience) is to be as open as possible and play by the rules
> of
> > > the Linux kernel community. This means that:
> > >
> > > - Big subsystems such as syslink should be broken down to small pieces,
> > > and every piece, especially the low-level ones, must be carefully
> designed
> > > with the whole Linux kernel in mind, not only the OMAP4 platform. APIs
> > > should be made generic when possible.
> > >
> > > - The VPSS MCU firmware should be properly documented, developed in
> the
> > > open and under an open-source license.
> >
> > Thanks for the guidance on this.  This is the kind of feedback we needed.
>
> You're welcome.
>
> > > Those two steps should be performed in tight cooperation with the
> Linux
> > > kernel community.
>
> --
> Regards,
>
> Laurent Pinchart
