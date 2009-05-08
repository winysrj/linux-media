Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2162 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZEHGpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2009 02:45:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Scoping the effort to add a media controller )Re: [ivtv-users] Delay loading v4l-cx25840.fw)
Date: Fri, 8 May 2009 08:45:10 +0200
Cc: linux-media@vger.kernel.org
References: <1241054296.3374.44.camel@palomino.walls.org> <200905021749.29207.hverkuil@xs4all.nl> <1241739191.4035.3.camel@palomino.walls.org>
In-Reply-To: <1241739191.4035.3.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905080845.10438.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 08 May 2009 01:33:11 Andy Walls wrote:
> On Sat, 2009-05-02 at 17:49 +0200, Hans Verkuil wrote:
> > On Friday 01 May 2009 04:21:36 Andy Walls wrote:
> > > On Wed, 2009-04-29 at 21:18 -0400, Andy Walls wrote:
> > > > On Wed, 2009-04-29 at 13:33 +0200, Hans Verkuil wrote:
> > >
> > > Hans, it sounds like your media_controller device node idea is really
> > > what we need to get implemented here for user space to do queires on
> > > hardware.  This problem obviously affects more than the ivtv driver
> > > so I'd recommend against an ivtv band-aid.
> > >
> > > We'd also want to coordinate with the hald folks and other user space
> > > app/plumbing developers, as this likely affects a few v4l2 drivers. 
> > > It sounds like an LPC agenda item to me...
> > >
> > > Regards,
> > > Andy
> >
> > I agree. A media controller device is exactly what we need. It's ideal
> > for applications and daemons like hald.
> >
> > Now all I need is the time to work on it and I don't see that happening
> > anytime soon. :-(
> >
> > Any volunteers? I have a general idea of how it should be implemented,
> > but it needs a fair amount of research as well.
>
> I recall a design document or brief: can you provide a pointer to them?
>
> What is the research that you think needs to be done?
>
> Regards,
> Andy
>
> > Regards,
> >
> > 	Hans

Hi Andy,

Here is a link to the original RFC:

http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.html

It's pretty old but the basic idea is still valid. I'll follow up this mail 
tonight or tomorrow with my latest thoughts on this subject and what the 
research is that has to be done.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
