Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48661 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2AOIof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 03:44:35 -0500
Date: Sun, 15 Jan 2012 10:44:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: v4l: how to get blanking clock count?
Message-ID: <20120115084429.GB11467@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
 <20111230213301.GA3677@valkosipuli.localdomain>
 <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
 <20111231113529.GC3677@valkosipuli.localdomain>
 <4EFEFA08.805@gmail.com>
 <CAHG8p1AjoV1gBhQGFm0rEYSkHrpG+XtQB7kYXc8x5nuqjW4Z4g@mail.gmail.com>
 <20120104082742.GL3677@valkosipuli.localdomain>
 <CAHG8p1DxPJthH8JOH9AEmLyCwas4O0f16ytk3FeknaPLnP_-2g@mail.gmail.com>
 <20120104093909.GA9323@valkosipuli.localdomain>
 <CAHG8p1BmtK5dydPZxsT7hoE1JoSFsN1MsXA0qaeVQBzpCeb0VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHG8p1BmtK5dydPZxsT7hoE1JoSFsN1MsXA0qaeVQBzpCeb0VQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On Wed, Jan 04, 2012 at 05:59:45PM +0800, Scott Jiang wrote:
> >> If I disable this interrupt, other errors like fifo underflow are ignored.
> >> Perhaps I can add a parameter in platform data to let user decide to
> >> register this interrupt or not.
> >
> > I think a more generic solution would be preferrable. If that causes
> > ignoring real errors, that's of course bad. I  wonder if there would be a
> > way around that.
> >
> > Is there a publicly available datasheet for the bridge that I could take a
> > look at?
> >
> Yes, http://www.analog.com/en/processors-dsp/blackfin/adsp-bf548/processors/technical-documentation/index.html.
> There is a hardware reference manual for bf54x, bridge is eppi.

Yeah, indeed it's the first time I see hardware like this. So to support
this properly, we truly need the new sensor control interface and an ability
to make those blanking values unchangeable.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
