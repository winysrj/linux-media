Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6PAbLsG018474
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 06:37:21 -0400
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6PAaZoB024863
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 06:36:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com, dbhat@linsys.ca
Date: Fri, 25 Jul 2008 12:36:30 +0200
References: <4888AF8B.9030609@linsys.ca>
In-Reply-To: <4888AF8B.9030609@linsys.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251236.30702.hverkuil@xs4all.nl>
Cc: 
Subject: Re: V4L for DVB ASI
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Dinesh,

On Thursday 24 July 2008 18:36:27 Dinesh Bhat wrote:
> Hello,
>
> We are DVB ASI PCI/PCIe card manufacturers in Canada. Some of you may
> have heard about our distributors: DVEO/Computer Modules. We
> encourage open source and use open source to develop our Linux
> products. I have been doing some research on getting our already open
> sourced DVB ASI drivers to work with either v4l or the regular DVB
> API.
>
> I had asked a question to the community a while ago and have had few
> responses. The question was mainly to find out if there is any
> interest in the community towards this goal. We will be happy to work
> with you. The initial response was to work on v4l as opposed to the
> DVB API. Since the cards support PID filtering and other transport
> stream analysis, I am encouraged to use DVB API instead of V4L
> because of TS feature support at the software level. But then I could
> be wrong since I have not done a lot of research on these two APIs.
> Sigmund Augdal had listed out the pros and cons to my previous
> question:
>
> Use the DVB Api:
> pros:
>  * you can take advantage of the software pid and section filters in
> the dvb framework
>  * if your device supports hardware pid/section filters, apis will be
> available to take advantage of them
>  * userspace applications that handle mpeg2 ts often use this api,
> and would be easy to adapt.
> cons:
>  * you might need to extend the apis to handle asi cards
>
> Use the v4l2 api:
> pros:
>  * semantics are well defined.
>  * provides an extensible api using so called "controls"
> cons:
>  * adapting user space applications will be more difficult
>  * no reuse of software filters
>
> If Anybody wants to look at the drivers, they are available at
> http://www.linsys.ca in customer support section.

Since I am heavily involved in the MPEG support for V4L2 I suspect that 
I am probably the right person to look into this. I must have missed 
this the first time you mailed it, probably because the subject didn't 
mention V4L. I am not involved in the DVB API, with the exception of 
the MPEG decoding part of it (dvb/video.h, dvb/audio.h) since my ivtv 
driver uses that for the MPEG decoding.

Looking over the functionality of ASI I see (correct me if I am wrong) 
that it is basically a transport standard for MPEG-TS streams as used 
in DVB applications. There is no routing, tuning or (de)modulating 
involved. The device is fed one or more MPEG-TS streams, they are muxed 
and timestamped and sent out over the ASI connection. And it can also 
receive an MPEG-TS stream and is able to demux that depending on the 
PIDs.

In my personal opinion I would say that this falls under the V4L API 
(with perhaps some use of the video.h/audio.h interfaces from DVB). 
Regardings the cons that are mentioned: since there is no standard for 
the ASI API all user space apps need to be converted anyway if a 
standard would appear. And as I understand it, any filtering is done in 
hardware.

Looking at the ioctls of your driver I would say that most if not all of 
these can be implemented as controls. Based on the admittedly limited 
information I have I see no obstacle of getting this into the v4l 
framework.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
