Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:59098 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0INNti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 09:49:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v4 00/11] Media controller (core and V4L2)
Date: Tue, 14 Sep 2010 15:49:33 +0200
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201009141425.28000.laurent.pinchart@ideasonboard.com> <c7863d81c584fe789fe36bd1abc9504d.squirrel@webmail.xs4all.nl>
In-Reply-To: <c7863d81c584fe789fe36bd1abc9504d.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141549.33648.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Tuesday 14 September 2010 15:24:41 Hans Verkuil wrote:
> > On Thursday 09 September 2010 03:44:15 Mauro Carvalho Chehab wrote:
> >
> >> It should also say that no driver should just implement the media
> >> controller API.
> > 
> > I haven't thought about that, as it would be pretty useless :-)
> 
> I actually think that it should be possible without too much effort to
> make the media API available automatically for those drivers that do not
> implement it themselves. For the standard drivers it basically just has to
> enumerate what is already known.
> 
> It would help a lot with apps like MythTV that want to find related
> devices (e.g. audio/video/vbi).

I think Mauro meant that no driver should implement the media controller API 
without implementing any other standard API (ALSA, DVB, FB, IR, V4L, ...).

-- 
Regards,

Laurent Pinchart
