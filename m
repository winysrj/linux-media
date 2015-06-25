Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbFYQda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 12:33:30 -0400
Message-ID: <1435249995.3761.55.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] [media] videobuf2: add trace events
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Thu, 25 Jun 2015 18:33:15 +0200
In-Reply-To: <20150625090724.09fb03f8@gandalf.local.home>
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
	 <1435226487-24863-2-git-send-email-p.zabel@pengutronix.de>
	 <20150625090724.09fb03f8@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 25.06.2015, 09:07 -0400 schrieb Steven Rostedt:
> On Thu, 25 Jun 2015 12:01:27 +0200
> Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> > index 89d0497..3d15cf1 100644
> > --- a/include/trace/events/v4l2.h
> > +++ b/include/trace/events/v4l2.h
> > @@ -175,9 +175,108 @@ SHOW_FIELD
> >  		)							\
> >  	)
> >  
> > +#define VB2_TRACE_EVENT(event_name)					\
> 
> This is what we have DECLARE_EVENT_CLASS for. Please use that,
> otherwise you are adding about 5k of text per event (where as
> DEFINE_EVENT adds only about 250 bytes).
[...]
> While you are at it, nuke the above macro and convert that too.

Thanks, I'll do that.

regards
Philipp

