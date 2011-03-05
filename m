Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41509 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1CEQhA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 11:37:00 -0500
Received: by wwb22 with SMTP id 22so3718517wwb.1
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 08:36:58 -0800 (PST)
Message-ID: <4D7266A8.3070602@gmail.com>
Date: Sat, 05 Mar 2011 17:36:56 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [ANN] First draft of the agenda for the Warsaw meeting
References: <201103051620.31840.hverkuil@xs4all.nl>
In-Reply-To: <201103051620.31840.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/05/2011 04:20 PM, Hans Verkuil wrote:
> Hi all!
> 
> Here is the first draft of the agenda for the Warsaw meeting. Next weekend
> I'll prepare the final version.
> 
> Please let me know any changes to/errors in the attendee list!
> 
> I tried to order the agenda so we start gently (I hope!) and mix large and
> small items.
> 
> I tried to name the main 'proponents' or 'stakeholders' for each item. Let
> me know if I am missing someone.
> 
> For each item I added links to mailinglist discussions. I'm sure I'm missing
> links, so please let me know and I'll add it to the final agenda.
> 
> If there are items missing, let me know as well. Although I suspect there
> won't be time for anything complicated.
> 
> 	Hans
> 
> 
> Draft Agenda for V4L2 brainstorm meeting in Warsaw, March 16-18 2011.
> =====================================================================
> 
> Purpose of the meeting: to brainstorm about current V4L2 API limitations
> with regards to required functionality. Ideally the results of the meeting
> are actual solutions to these problems, but at the very least we should
> have a concensus of what direction to take and who will continue working
> on each problem. The hope is that this meeting will save us endless email
> and irc discussions.
> 
> It is *not* a summit meeting, so any conclusions need to be discussed and
> approved on the mailinglist.
> 
> The basic outline is the same as during previous meetings: the first day we
> go through all the agenda points and make sure everyone understands the
> problem. Smaller issues will be discussed and decided, more complex issues
> are just discussed.
> 
> The second day we go in depth into the complex issues and try to come up with
> ideas that might work. The last day we translate the all agenda items into
> actions.
> 
> This approach worked well in the past and it ensures that we end up with
> something concrete.
> 
> Those who have a vested interest in an agenda item should be prepared to
> explain their take on it and if necessary have a presentation ready.
> 
> Besides the main agenda I also added a few items falling under the category
> 'if time permits'.
> 
> Attendees:
> 
> Samsung Poland R&D Center:
>    Kamil Debski
>    Sylwester Nawrocki
>    Tomasz Stanislawski
>    Marek Szyprowski (Organizer)
> 
> Cisco Systems Norway:
>    Martin Bugge
>    Hans Verkuil (Chair)
> 
> Nokia:
>    Sakari Ailus
> 
> Ideas On Board:
>    Laurent Pinchart
> 
> ST-Ericsson:
>    Willy Poisson
> 
> Samsung Korea (is this correct?):

Yes, that's right. Exactly it's Samsung System LSI Division, Korea.
Thanks to Mr. Han and Mr. Oh for joining us! :)

>    Jonghun Han
>    Jaeryul Oh
> 
> Freelance:
>    Guennadi Liakhovetski
> 
> 
> Agenda:
> 
> 1) Compressed format API for MPEG, H.264, etc. Also need to discuss what to
>     do with weird 'H.264 inside MJPEG' muxed formats.
>     (Hans, Laurent, Samsung)
> 
> 2) Subdev architecture enhancements:
> 	- Acquiring subdevs from other devices using subdev pool
> 	  http://www.mail-archive.com/linux-media@vger.kernel.org/msg21831.html
> 	- Introducing subdev hierarchy. Below there is a link to driver using it:
> 	  http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28885/focus=28890
>     (Tomasz)
> 
> 3) Entity information ioctl
> 
>     (Laurent)
> 
> 4) Pipeline configuration, cropping and scaling:
> 
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html
> 
>     (Everyone)
> 
> 5) HDMI receiver/transmitter API support
> 
>     Some hotplug/CEC code can be found here:
> 
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
> 
>     CEC RFC from Cisco Systems Norway:
> 
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg28735.html
> 
>     (Martin, Hans, Samsung, ST-Ericsson)
> 
> 6) Sensor/Flash/Snapshot functionality.
> 
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html
> 
>     - Sensor blanking/pixel-clock/frame-rate settings (including
>       enumeration/discovery)
> 
>     - Multiple video buffer queues per device (currently implemented in the
>       OMAP 3 ISP driver in non-standard way).
> 
>     - Synchronising parameters (e.g. exposure time and gain) on given
>       frames. Some sensors support this on hardware. There are many use cases
>       which benefit from this, for example this one:
> 
>       <URL:http://fcam.garage.maemo.org/>
> 
>     - Flash synchronisation (might fall under the above topic).
> 
>     - Frame metadata. It is important for the control algorithms (exposure,
>       white balance, for example), to know which sensor settings have been
>       used to expose a given frame. Many sensors do support this. Do we want
>       to parse this in the kernel or does it belong to user space? The
>       metadata formats are mostly sensor dependent.
> 

I'd like to discuss also, as time permits, handling of EXIF files produced by more
complex Image Sensor Processors like Fujitsu M-5MOLS or NEC CE147. Perhaps we
could exploit the EXIF standard (http://www.exif.org/Exif2-2.PDF) to encapsulate
different sensors/ISP formats in the drivers end expose uniform interface 
to applications. Not sure.. Other than that the EXIF tags and components may
need to be tweaked in the sensor, for example the thumbnail resolution and color
format. I suppose it might be worth to think about a set of EXIF controls.

I'll try to have a list of at least basic requirements ready before the meeting.

Regards,
Sylwester

>     (Everyone)
> 
> 
> Items 4 and 6 are 'the big ones'. Past experience indicates that we can't go
> through all items on the first day and so I expect that item 6 (and perhaps
> even 5) will have to move to the second day.
> 
> 
> If time permits, then we can also look at these items:
> 
> A) Buffer Pool (HWMEM, GEM, CMA)
>     (ST-Ericsson, Samsung)
> 
> B) Use of V4L2 as a frontend for SW/DSP codecs
>     (Laurent)
> 
> The reason I put these items here is that I think that these are not quite as
> urgent as the others, and given that we only have three days we have to make
> a choice. I also think that these items are probably worth a full three-day
> meeting all by themselves.
> 
> Regards,
> 
> 	Hans
> 

