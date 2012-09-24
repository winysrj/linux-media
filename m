Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47227 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757357Ab2IXUMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 16:12:23 -0400
Date: Mon, 24 Sep 2012 23:12:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chris MacGregor <chris@cybermato.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
Message-ID: <20120924201218.GL12025@valkosipuli.retiisi.org.uk>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
 <50603C39.9060105@redhat.com>
 <CA+V-a8uLhTTTOMNtz-iL=HZ0M+D6LgU4nbttcbb9Ej1cNDQMEQ@mail.gmail.com>
 <506095A7.7020302@cybermato.com>
 <5060AA68.6050208@redhat.com>
 <5060B171.8060103@cybermato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060B171.8060103@cybermato.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris and Hans,

On Mon, Sep 24, 2012 at 12:16:01PM -0700, Chris MacGregor wrote:
...
> >  (I have patches to add the controls, but I haven't had time yet
> >to get them into good enough shape to submit - sorry!)
> >>
> >>It seems to me that for applications that want to set them to
> >>the same value (presumably the vast majority), it is not so hard
> >>to set both the green_red and green_blue.  If you implement a
> >>single control, what happens for the (admittedly rare)
> >>application that needs to control them separately?
> >
> >Well if these are showing up in something like a user oriented
> >control-panel (which they may) then having one slider for both
> >certainly is more userfriendly.
> 
> Okay, that's a fair point.  But an application that wanted to could
> insulate the user from it fairly easily.
> 
> I'm not opposed to having a single control, *if* there is some way
> for apps to control the greens separately when they need to.  I
> don't have a brilliant solution for this offhand, other than just
> exposing the separate controls.

I do recognise there's a need for developers to fiddle with such low level
controls as these but I can hardly see end users using them as such. Either
automatic white balance or a white balance control with higher level of
abstraction is likely better for that purpose.

Some sensors have only a single gain for the greens so these devices should
anyway implement just a single green gain (which is neither of the two).
Perhaps such abstraction could be performed by libv4l?

Just my 0,05 euros.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
