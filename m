Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:36267 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZCMH1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 03:27:23 -0400
Date: Fri, 13 Mar 2009 00:27:21 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
Subject: Re: identifying camera sensor
In-Reply-To: <19261.62.70.2.252.1236245550.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903122357340.28292@shell2.speakeasy.net>
References: <19261.62.70.2.252.1236245550.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Hans Verkuil wrote:
> Reserved bits are there for a reason. If a particular bit of information
> it a perfect match with for that API, then it seems utterly pointless to
> me to decide not to use them 'just because we might run out in the
> future'.

It would be one thing if there was just a possibility of them running out
in the distant future.  Rather, they'll run out before you even get started
on adding what's already available for digital cameras.  Focus distance,
exposure compensation, sensor manufacture and model, gravity sensors,
detailed gamma compensation curves, and so on.

>
> > Though if one had considered allowing the control api to be used to
> > provide
> > sensor properties, then the solution to this problem would now be quite
> > simple and obvious.
>
> In this case you want to have device names. While not impossible, it is
> very hard to pass strings over the control api. Lots of issues with 32-64
> bit compatibility and copying to/from user space. Also, in this case the

That's true.  While I think the control api is the best one for providing
ancillary data for images and sensor attributes, it's not perfect.  I'd add
a means to define the data type of a control/attribute and allow things
besides an s32.  Probably ASCIIZ strings and fix length byte arrays.

Also flags for:

constant vs volatile
  Constant attributes don't change, e.g. sensor manufacturer name.  Volatile
  ones can change, e.g. focus distance.

global vs per-input
  Global attributes are the same for the entire device, while per-input
  attributes are different for each input.  An API for querying the
  attribute for an input different the current might be nice, but I think
  it might be one of things that seem more important than they really are.

Frame syncable
  Frame syncable attributes (which only make sense for volatile attributes)
  can be synced to the exact frame they were measured at.  For instance,
  the the camera provides a focus distance value for software face
  tracking, it's important that the right focus distance be associated with
  the correct frame.  There should be an API by which one can request that
  the attribute be provided with each frame, maybe tacked onto the end of
  the v4l2_buffer structure.

> control API is NOT a good match, since this isn't a single piece of data,
> instead you can have multiple sensor devices or other video enhancement
> devices that an application might need to know about. Which is why my last
> brainstorm suggestion was an ENUM_CHIPS ioctl.

How would enum chips be different than enum controls?
