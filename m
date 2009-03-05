Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:60754 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZCEI7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 03:59:48 -0500
Date: Thu, 5 Mar 2009 00:59:46 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
Subject: Re: identifying camera sensor
In-Reply-To: <20296.62.70.2.252.1236242449.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903050049130.24268@shell2.speakeasy.net>
References: <20296.62.70.2.252.1236242449.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Hans Verkuil wrote:
>
> ENUMINPUT is probably a better solution: you can say something like
> "Camera 1 (sensor1)", "Camera 2 (sensor2)".
>
> It remains a bit of a hack, though.

Maybe use some of the reserved bits in v4l2_input to show not only the
sensor orientation, but also manufacturer, model, and revision?  I wonder
if there are enough bits for that?

How does this discussion go?  I point out that using reserved bits is not
sustainable, does not allow enumeration of supplied properties, and
provides no meta-data for the self-documentation of those properties.  The
control interface provides all these things.  Then you point out that these
aren't "controls" and say end of discussion.

Though if one had considered allowing the control api to be used to provide
sensor properties, then the solution to this problem would now be quite
simple and obvious.
