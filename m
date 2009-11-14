Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-roam1.Stanford.EDU ([171.67.219.88]:54885 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751411AbZKNULZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2009 15:11:25 -0500
Message-ID: <4AFF0EE3.8060300@stanford.edu>
Date: Sat, 14 Nov 2009 12:11:15 -0800
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
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
References: <4AE182DD.6060103@maxwell.research.nokia.com>    <200911110819.59521.hverkuil@xs4all.nl>    <4AFAF490.6090507@maxwell.research.nokia.com>    <200911111859.09500.hverkuil@xs4all.nl>    <20091113132947.0d307bfd@pedra.chehab.org> <0b8a6359111ae13de1c0fbf5146618da.squirrel@webmail.xs4all.nl> <4AFD97BF.9000703@stanford.edu> <4AFDADFF.2030503@maxwell.research.nokia.com>
In-Reply-To: <4AFDADFF.2030503@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2009 11:05 AM, Sakari Ailus wrote:
> Eino-Ville Talvala wrote:
>> I think we have a use case for events that would require correlating 
>> with frames, although I agree that the buffer index would be far 
>> simpler to match with than a timestamp.  The specific feature is 
>> letting the application know exactly what sensor settings were used 
>> with a given frame, which is essential for our slowly-developing 
>> computational camera API, which will be changing sensor parameters on 
>> nearly every frame boundary.
>>
>> I think one event is probably sufficient to encode the relevant 
>> register values of our sensor.  Would you expect there to be any 
>> issue with having an event happen per frame?
>
> I do expect several events per frame from the AEWB, AF and histogram 
> statistics and no problems. :-)
>
> But if I understand correctly, the registers are some kind of metadata 
> associated to the frame? That perhaps includes exposure time, gain 
> etc. The events interface would be good for this if the metadata fits 
> to a single v4l2_event structure. A new ioctl could be an alternative, 
> perhaps it could be a private ioctl first.
>
> This is more or less comparable to the H3A statistics IMO. So the user 
> space gets an event and can query the H3A data.
>
> Associating events to a single frame is slightly troublesome since a 
> succesful frame reception is only certain when it already has 
> happened. There could be a metadata event and after that a receive 
> buffer overflow that spoils the frame. In that case the field_count 
> could be just incremented without dequeueing any buffers, though.
>
Right, all of the sensor settings that applied to that particular 
frame.  We're changing the sensor settings on nearly every frame, so 
it's fairly key to keep track of them in some way, and events seem to be 
far nicer solution than what we currently do (which involves abusing the 
frame input field, as it was the fastest thing I saw to hack in).

Of course, the event queue and frame queue would have to be kept in 
sync, or just let the app discard events that apply to frames it never 
saw - as long as the event queue is a bit bigger than the frame queue, I 
don't think there'd be a problem in practice.

Eino-Ville Talvala
Camera 2.0 Project
Stanford University
