Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3985 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZIJRMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 13:12:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Volunteer for V4L2+Audio at Plumbers Conference?
Date: Thu, 10 Sep 2009 19:12:22 +0200
Cc: linux-media@vger.kernel.org
References: <200909080837.31989.hverkuil@xs4all.nl> <829197380909080641q3ff2cd15r6150d36f2a4ee809@mail.gmail.com>
In-Reply-To: <829197380909080641q3ff2cd15r6150d36f2a4ee809@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909101912.22933.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 08 September 2009 15:41:38 Devin Heitmueller wrote:
> On Tue, Sep 8, 2009 at 2:37 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> > Hi all,
> >
> > I'm looking for a v4l-dvb developer who is at the Plumbers Conference to
> > attend the audio miniconference on Wednesday morning (see schedule here:
> > http://linuxplumbersconf.org/2009/schedule/) and to discuss ways of
> > synchronizing video and audio.
> >
> > I won't have time for that myself, and I also know very little about alsa.
> > But this is an open topic that we need to do something about and this
> > conference is a good place for that.
> >
> > Regards,
> >
> >        Hans
> 
> Hello Hans,
> 
> I will be attending the audio seminars, since I have a keen interest
> in finally getting the audio and video streams properly associated for
> raw analog video (so that applications such as tvtime will work
> out-of-the-box).
> 
> I would be happy to meet up with you afterward and share my notes.

Devin,

If we have a media controller framework, then we might be able to use that as
an alternative way to get timestamps. See note 4 at the end of the RFC that
I posted today. If it turns out that there is no decent way of handling this
in alsa, then we have at least a way out.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
