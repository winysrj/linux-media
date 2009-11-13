Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37438 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZKMTGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 14:06:03 -0500
Message-ID: <4AFDADFF.2030503@maxwell.research.nokia.com>
Date: Fri, 13 Nov 2009 21:05:35 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Eino-Ville Talvala <talvala@stanford.edu>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFC] Video events, version 2.2
References: <4AE182DD.6060103@maxwell.research.nokia.com>    <200911110819.59521.hverkuil@xs4all.nl>    <4AFAF490.6090507@maxwell.research.nokia.com>    <200911111859.09500.hverkuil@xs4all.nl>    <20091113132947.0d307bfd@pedra.chehab.org> <0b8a6359111ae13de1c0fbf5146618da.squirrel@webmail.xs4all.nl> <4AFD97BF.9000703@stanford.edu>
In-Reply-To: <4AFD97BF.9000703@stanford.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eino-Ville Talvala wrote:
> I think we have a use case for events that would require correlating 
> with frames, although I agree that the buffer index would be far simpler 
> to match with than a timestamp.  The specific feature is letting the 
> application know exactly what sensor settings were used with a given 
> frame, which is essential for our slowly-developing computational camera 
> API, which will be changing sensor parameters on nearly every frame 
> boundary.
> 
> I think one event is probably sufficient to encode the relevant register 
> values of our sensor.  Would you expect there to be any issue with 
> having an event happen per frame?

I do expect several events per frame from the AEWB, AF and histogram 
statistics and no problems. :-)

But if I understand correctly, the registers are some kind of metadata 
associated to the frame? That perhaps includes exposure time, gain etc. 
The events interface would be good for this if the metadata fits to a 
single v4l2_event structure. A new ioctl could be an alternative, 
perhaps it could be a private ioctl first.

This is more or less comparable to the H3A statistics IMO. So the user 
space gets an event and can query the H3A data.

Associating events to a single frame is slightly troublesome since a 
succesful frame reception is only certain when it already has happened. 
There could be a metadata event and after that a receive buffer overflow 
that spoils the frame. In that case the field_count could be just 
incremented without dequeueing any buffers, though.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
