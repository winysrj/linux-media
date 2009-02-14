Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45545 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbZBNVvZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 16:51:25 -0500
Message-ID: <49973DDB.7000109@redhat.com>
Date: Sat, 14 Feb 2009 22:55:39 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
References: <200902142048.51863.linux@baker-net.org.uk>
In-Reply-To: <200902142048.51863.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Adam Baker wrote:
> Hi all,
> 
> Hans Verkuil put forward a convincing argument that sensor orientation 
> shouldn't be part of the buffer flags as then it would be unavailable to 
> clients that use read()

Yes and this is a bogus argument, clients using read also do not get things 
like timestamps, and vital information like which field is in the read buffer 
when dealing with interleaved sources. read() is a simple interface for simple 
applications. Given that the only user of these flags will likely be libv4l I 
*strongly* object to having this info in some control, it is not a control, it 
is a per frame (on some cams) information about how to interpret that frame, 
the buffer flags is a very logical place, *the* logical place even for this!

The fact that there is no way to transport metadata about a frame like flags, 
but also timestamp and field! Is a problem with the read interface in general, 
iow read() is broken wrt to this. If people care add some ioctl or something 
which users of read() can use to get the buffer metadata from the last read() 
buffer, stuffing buffer metadata in a control (barf), because of read() 
brokenness is a very *bad* idea, and won't work in general due to 
synchronization problems.

Doing this as a control will be a pain to implement both at the driver level, 
see the discussion this is causing, and in libv4l. For libv4l this will basicly 
mean polling the control. And hello polling is lame and something from the 
1980-ies.

Please just make this a buffer flag.

Thank you,

Hans
