Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3544 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1CIHrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 02:47:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: jaeryul.oh@samsung.com
Subject: Re: [ANN] First draft of the agenda for the Warsaw meeting
Date: Wed, 9 Mar 2011 08:47:01 +0100
Cc: "'linux-media'" <linux-media@vger.kernel.org>
References: <201103051620.31840.hverkuil@xs4all.nl> <010a01cbde28$d857c540$89074fc0$%oh@samsung.com>
In-Reply-To: <010a01cbde28$d857c540$89074fc0$%oh@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201103090847.01661.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, March 09, 2011 08:08:43 Jaeryul Oh wrote:
> Hi, Hans
> 
> We want to confirm if it is possible to discuss our concerning points 
> at each item of 1st draft that you made as below. 
> 
> Our concerning items that we want to discuss are :
> 
> 1. Issues when using V4l2 control framework with codec
>    : http://www.spinics.net/lists/linux-media/msg27975.html
>    : Can we discuss 'V4l2 control framework to support codec' in your first
> agenda ?
>      (Compressed format API for MPEG, H.264, etc. xxx)
>    : We will post related contents in mailing list before joining Warsaw
> meeting. 

Certainly. If I am not mistaken the required control framework changes you
refer to in the supplied link are actually done in Laurent's media
controller/OMAP3 patch series, so these should appear any day now.

> 
> 2.  Subdev architecture enhancements(second agenda)
>    :
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/29442
> /focus=29570
>      -> We posted our issue(subdev related) as above link, and 
>          If it(Subdev architecture enhancements)is applied, it might resolve
> our issue. 
>    :  So, we want to talk about some problem & solving way in second agenda
> 
> 3. Which interface is better for Mixer of Exynos, frame buffer or V4l2 ?
>    : http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
>     -> Here at fifth agenda (HDMI receiver/transmitter API support),
>         We want to discuss that frame buffer interface is more suitable for
> Mixer.
>         Can we discuss that here ? 

I think I'll combine 2 and 3 to a new 'framebuffer & V4L2' topic.

> 4. Method for sharing buffer b/w processes
>   : http://www.spinics.net/lists/linux-media/msg29936.html
>   : This is one of big topics, I know
>   : In Warsaw meeting we would like to share the SDVMM concept for buffer
> sharing.
>     I know it's a very huge topic. But if you arrange the priority of it in
> the agenda, 
>     one more person in Samsung(S.LSI) will attend the meeting 
>     even though it is just a concept sharing.
>     As I know, ST-Ericsson also uses Mali(ARM GPU).
>     I also want to hear the usage from Willy Poisson.
>   : Can we discuss this items at 'Buffer Pool(HWMEM, GEM, CMA)' ? 

No, not a good idea. This issue needs its own (brainstorm) meeting(s). I have
it as a 'if time permits' topic, but I very much doubt that we will have time.

As I mentioned in other posts, I think that linaro should organize a meeting
with all the main stakeholders to find a solution that all parties can agree
to. It seems that almost all of the linaro sponsors have their own solution,
so I'd say that linaro is the ideal organization to pull this.

Since Samsung is one of the sponsors I recommend that you help linaro in
setting this up.

It might be useful to have a separate brainstorm meeting were we go through
the V4L2 requirements and look at the various solutions as a preparation for
a linaro meeting. So we know what the needs of the V4L2 subsystem are. That
might be something that Samsung LSI could set up.

This issue is quickly becoming the most important remaining problem when it
comes to video handling in embedded systems. I think it is technically not
even that difficult, but it requires kernel-wide consensus. This requires
meetings, and those require money to organize and to sponsor the travel of
those developers who can't get the money.

Regards,

	Hans

> 
> 
> 
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Hans Verkuil
> > Sent: Sunday, March 06, 2011 12:21 AM
> > To: linux-media
> > Subject: [ANN] First draft of the agenda for the Warsaw meeting
> > 
> > Hi all!
> > 
> > Here is the first draft of the agenda for the Warsaw meeting. Next weekend
> > I'll prepare the final version.
> > 
> > Please let me know any changes to/errors in the attendee list!
> > 
> > I tried to order the agenda so we start gently (I hope!) and mix large and
> > small items.
> > 
> > I tried to name the main 'proponents' or 'stakeholders' for each item. Let
> > me know if I am missing someone.
> > 
> > For each item I added links to mailinglist discussions. I'm sure I'm
> > missing
> > links, so please let me know and I'll add it to the final agenda.
> > 
> > If there are items missing, let me know as well. Although I suspect there
> > won't be time for anything complicated.
> > 
> > 	Hans
> > 
> > 
> > Draft Agenda for V4L2 brainstorm meeting in Warsaw, March 16-18 2011.
> > =====================================================================
> > 
> > Purpose of the meeting: to brainstorm about current V4L2 API limitations
> > with regards to required functionality. Ideally the results of the meeting
> > are actual solutions to these problems, but at the very least we should
> > have a concensus of what direction to take and who will continue working
> > on each problem. The hope is that this meeting will save us endless email
> > and irc discussions.
> > 
> > It is *not* a summit meeting, so any conclusions need to be discussed and
> > approved on the mailinglist.
> > 
> > The basic outline is the same as during previous meetings: the first day
> > we
> > go through all the agenda points and make sure everyone understands the
> > problem. Smaller issues will be discussed and decided, more complex issues
> > are just discussed.
> > 
> > The second day we go in depth into the complex issues and try to come up
> > with
> > ideas that might work. The last day we translate the all agenda items into
> > actions.
> > 
> > This approach worked well in the past and it ensures that we end up with
> > something concrete.
> > 
> > Those who have a vested interest in an agenda item should be prepared to
> > explain their take on it and if necessary have a presentation ready.
> > 
> > Besides the main agenda I also added a few items falling under the
> > category
> > 'if time permits'.
> > 
> > Attendees:
> > 
> > Samsung Poland R&D Center:
> >   Kamil Debski
> >   Sylwester Nawrocki
> >   Tomasz Stanislawski
> >   Marek Szyprowski (Organizer)
> > 
> > Cisco Systems Norway:
> >   Martin Bugge
> >   Hans Verkuil (Chair)
> > 
> > Nokia:
> >   Sakari Ailus
> > 
> > Ideas On Board:
> >   Laurent Pinchart
> > 
> > ST-Ericsson:
> >   Willy Poisson
> > 
> > Samsung Korea (is this correct?):
> >   Jonghun Han
> >   Jaeryul Oh
> > 
> > Freelance:
> >   Guennadi Liakhovetski
> > 
> > 
> > Agenda:
> > 
> > 1) Compressed format API for MPEG, H.264, etc. Also need to discuss what
> > to
> >    do with weird 'H.264 inside MJPEG' muxed formats.
> >    (Hans, Laurent, Samsung)
> > 
> > 2) Subdev architecture enhancements:
> > 	- Acquiring subdevs from other devices using subdev pool
> > 	  http://www.mail-archive.com/linux-
> > media@vger.kernel.org/msg21831.html
> > 	- Introducing subdev hierarchy. Below there is a link to driver
> > using it:
> > 	  http://thread.gmane.org/gmane.linux.drivers.video-input-
> > infrastructure/28885/focus=28890
> >    (Tomasz)
> > 
> > 3) Entity information ioctl
> > 
> >    (Laurent)
> > 
> > 4) Pipeline configuration, cropping and scaling:
> > 
> >    http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
> >    http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html
> > 
> >    (Everyone)
> > 
> > 5) HDMI receiver/transmitter API support
> > 
> >    Some hotplug/CEC code can be found here:
> > 
> >    http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
> > 
> >    CEC RFC from Cisco Systems Norway:
> > 
> >    http://www.mail-archive.com/linux-media@vger.kernel.org/msg28735.html
> > 
> >    (Martin, Hans, Samsung, ST-Ericsson)
> > 
> > 6) Sensor/Flash/Snapshot functionality.
> > 
> >    http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
> >    http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html
> > 
> >    - Sensor blanking/pixel-clock/frame-rate settings (including
> >      enumeration/discovery)
> > 
> >    - Multiple video buffer queues per device (currently implemented in the
> >      OMAP 3 ISP driver in non-standard way).
> > 
> >    - Synchronising parameters (e.g. exposure time and gain) on given
> >      frames. Some sensors support this on hardware. There are many use
> > cases
> >      which benefit from this, for example this one:
> > 
> >      <URL:http://fcam.garage.maemo.org/>
> > 
> >    - Flash synchronisation (might fall under the above topic).
> > 
> >    - Frame metadata. It is important for the control algorithms (exposure,
> >      white balance, for example), to know which sensor settings have been
> >      used to expose a given frame. Many sensors do support this. Do we
> want
> >      to parse this in the kernel or does it belong to user space? The
> >      metadata formats are mostly sensor dependent.
> > 
> >    (Everyone)
> > 
> > 
> > Items 4 and 6 are 'the big ones'. Past experience indicates that we can't
> > go
> > through all items on the first day and so I expect that item 6 (and
> > perhaps
> > even 5) will have to move to the second day.
> > 
> > 
> > If time permits, then we can also look at these items:
> > 
> > A) Buffer Pool (HWMEM, GEM, CMA)
> >    (ST-Ericsson, Samsung)
> > 
> > B) Use of V4L2 as a frontend for SW/DSP codecs
> >    (Laurent)
> > 
> > The reason I put these items here is that I think that these are not quite
> > as
> > urgent as the others, and given that we only have three days we have to
> > make
> > a choice. I also think that these items are probably worth a full three-
> > day
> > meeting all by themselves.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > --
> > Hans Verkuil - video4linux developer - sponsored by Cisco
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
