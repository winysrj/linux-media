Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1228 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZBNV76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 16:59:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Adding a control for Sensor Orientation
Date: Sat, 14 Feb 2009 22:59:44 +0100
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Olivier Lorin <o.lorin@laposte.net>
References: <200902142048.51863.linux@baker-net.org.uk> <49973DDB.7000109@redhat.com>
In-Reply-To: <49973DDB.7000109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142259.44431.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 22:55:39 Hans de Goede wrote:
> Adam Baker wrote:
> > Hi all,
> >
> > Hans Verkuil put forward a convincing argument that sensor orientation
> > shouldn't be part of the buffer flags as then it would be unavailable
> > to clients that use read()
>
> Yes and this is a bogus argument, clients using read also do not get
> things like timestamps, and vital information like which field is in the
> read buffer when dealing with interleaved sources. read() is a simple
> interface for simple applications. Given that the only user of these
> flags will likely be libv4l I *strongly* object to having this info in
> some control, it is not a control, it is a per frame (on some cams)
> information about how to interpret that frame, the buffer flags is a very
> logical place, *the* logical place even for this!
>
> The fact that there is no way to transport metadata about a frame like
> flags, but also timestamp and field! Is a problem with the read interface
> in general, iow read() is broken wrt to this. If people care add some
> ioctl or something which users of read() can use to get the buffer
> metadata from the last read() buffer, stuffing buffer metadata in a
> control (barf), because of read() brokenness is a very *bad* idea, and
> won't work in general due to synchronization problems.
>
> Doing this as a control will be a pain to implement both at the driver
> level, see the discussion this is causing, and in libv4l. For libv4l this
> will basicly mean polling the control. And hello polling is lame and
> something from the 1980-ies.
>
> Please just make this a buffer flag.

OK, make it a buffer flag. I've got to agree that it makes more sense to do 
it that way.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
