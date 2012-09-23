Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46597 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752508Ab2IWLns (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 07:43:48 -0400
Date: Sun, 23 Sep 2012 14:43:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	remi@remlab.net, daniel-gl@gmx.net,
	laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Timestamps and V4L2
Message-ID: <20120923114342.GF12025@valkosipuli.retiisi.org.uk>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk>
 <201209211133.24174.hverkuil@xs4all.nl>
 <505DB12F.1090600@iki.fi>
 <505DF194.9030007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505DF194.9030007@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, Sep 22, 2012 at 07:12:52PM +0200, Sylwester Nawrocki wrote:
> On 09/22/2012 02:38 PM, Sakari Ailus wrote:
> >> You are missing one other option:
> >>
> >> Using v4l2_buffer flags to report the clock
> >> -------------------------------------------
> >>
> >> By defining flags like this:
> >>
> >> V4L2_BUF_FLAG_CLOCK_MASK 0x7000
> >> /* Possible Clocks */
> >> V4L2_BUF_FLAG_CLOCK_UNKNOWN 0x0000 /* system or monotonic, we don't 
> >> know */
> >> V4L2_BUF_FLAG_CLOCK_MONOTONIC 0x1000
> >>
> >> you could tell the application which clock is used.
> >>
> >> This does allow for more clocks to be added in the future and clock 
> >> selection
> >> would then be done by a control or possibly an ioctl. For now there 
> >> are no
> >> plans to do such things, so this flag should be sufficient. And it can be
> >> implemented very efficiently. It works with existing drivers as well, 
> >> since
> >> they will report CLOCK_UNKNOWN.
> >>
> >> I am very much in favor of this approach.
> 
> +1
> 
> I think I like this idea best, it's relatively simple (even with adding
> support for reporting flags in VIDIOC_QUERYBUF) for the purpose.
> 
> If we ever need the clock selection API I would vote for an IOCTL.
> The controls API is a bad choice for something such fundamental as
> type of clock for buffer timestamping IMHO. Let's stop making the
> controls API a dumping ground for almost everything in V4L2! ;)

Why would the control API be worse than an IOCTL for choosing the type of
the timestamp? The control API after all has functionality for exactly for
this: this is an obvious menu control.

What comes to the nature of things that can be configured using controls and
what can be done using IOCTLs I see no difference. It's just a mechanism.
That's what traditional Unix APIs do in general: provide mechanism, not a
policy.

> > Thanks for adding this. I knew I was forgetting something but didn't 
> > remember what --- I swear it was unintentional! :-)
> > 
> > If we'd add more clocks without providing an ability to choose the clock 
> > from the user space, how would the clock be selected? It certainly isn't 
> > the driver's job, nor I think it should be system-specific either 
> > (platform data on embedded systems).
> > 
> > It's up to the application and its needs. That would suggest we should 
> > always provide monotonic timestamps to applications (besides a potential 
> > driver-specific timestamp), and for that purpose the capability flag --- 
> > I admit I disliked the idea at first --- is enough.
> > 
> > What comes to buffer flags, the application would also have to receive 
> > the first buffer from the device to even know what kind of timestamps 
> > the device uses, or at least call QUERYBUF. And in principle the flag 
> > should be checked on every buffer, unless we also specify the flag is 
> > the same for all buffers. And at certain point this will stop to make 
> > any sense...
> 
> Good point. Perhaps VIDIOC_QUERYBUF and VIDIOC_DQBUF should be reporting
> timestamps type only for the time they are being called. Not per buffer,
> per device. And applications would be checking the flags any time they
> want to find out what is the buffer timestamp type. Or every time if it
> don't have full control over the device (S/G_PRIORITY).

I think we should have valid timestamp flags for every buffer. What I meant
to say was that we should say in the definition that the flags will be the
same for every buffer --- that will hold until (or if) we provide a
mechanism for timestamp source selecton. In that canse the flags will
reflect the user-selected timestamp.

> > A capability flag is cleaner solution from this perspective, and it can 
> > be amended by a control (or an ioctl) later on: the flag can be 
> > disregarded by applications whenever the control is present. If the 
> > application doesn't know about the control it can still rely on the 
> > flag. (I think this would be less clean than to go for the control right 
> > from the beginning, but better IMO.)
> 
> But with the capability flag we would only be able to report one type of
> clock, right ?

That's true but doesn't that apply to any other non-application-selectable
timestamp source, apart from the device dependent timestamps?

> >>> Device-dependent timestamp
> >>> --------------------------
> >>>
> >>> Should we agree on selectable timestamps, the existing timestamp 
> >>> field (or a
> >>> union with another field of different type) could be used for the
> >>> device-dependent timestamps.
> >>
> >> No. Device timestamps should get their own field. You want to be able 
> >> to relate
> >> device timestamps with the monotonic timestamps, so you need both.
> >>
> >>> Alternatively we can choose to re-use the
> >>> existing timecode field.
> >>>
> >>> At the moment there's no known use case for passing device-dependent
> >>> timestamps at the same time with monotonic timestamps.
> >>
> >> Well, the use case is there, but there is no driver support. The device
> >> timestamps should be 64 bits to accomodate things like PTS and DTS from
> >> MPEG streams. Since timecode is 128 bits we might want to use two u64 
> >> fields
> >> or perhaps 4 u32 fields.
> > 
> > That should be an union for different kinds (or rather types) of 
> > device-dependent timestamps. On uvcvideo I think this is u32, not u64. 
> > We should be also able to tell what kind device dependent timestamp 
> > there is --- should buffer flags be used for that as well?
> 
> Timecode has 'type' and 'flags' fields, couldn't it be accommodated for 
> reporting device-dependant timestamps as well ?

The whole timdecode field should be removed as it no longer is used. At
least part of that will then be used for the device specific timestamp.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
