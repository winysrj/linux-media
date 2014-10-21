Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52257 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752425AbaJUJgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 05:36:15 -0400
Date: Tue, 21 Oct 2014 12:26:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v2 1/4] Add a media device configuration file parser.
Message-ID: <20141021092623.GF15257@valkosipuli.retiisi.org.uk>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
 <1413557682-20535-2-git-send-email-j.anaszewski@samsung.com>
 <20141020214415.GE15257@valkosipuli.retiisi.org.uk>
 <5446086C.5030705@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5446086C.5030705@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Oct 21, 2014 at 09:17:00AM +0200, Jacek Anaszewski wrote:
...
> >>+ * The V4L2 control group format:
> >>+ *
> >>+ * v4l2-controls {
> >>+ * <TAB><control1_name>: <entity_name><LF>
> >>+ * <TAB><control2_name>: <entity_name><LF>
> >>+ * ...
> >>+ * <TAB><controlN_name>: <entity_name><LF>
> >>+ * }
> >
> >I didn't know you were working on this.
> 
> Actually I did the main part of work around 1,5 year ago as a part
> of familiarizing myself with V4L2 media controller API.

:-D

I think it's about time we get things like this to libv4l.

> >
> >I have a small library which does essentially the same. The implementation
> >is incomplete, that's why I hadn't posted it to the list. We could perhaps
> >discuss this a little bit tomorrow. When would you be available, in case you
> >are?
> 
> I will be available around 8 hours from now on.

I couldn't see you on #v4l, would an hour from now (13:30 Finnish time) be
ok for you?

> >What would you think of using a little bit more condensed format for this,
> >similar to that of libmediactl?
> >
> 
> Could you spot a place where the format is defined?

At the moment there's none, but I thought of a similar format used by
libmediactl.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
