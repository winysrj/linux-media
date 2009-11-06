Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA6HBZWd022546
	for <video4linux-list@redhat.com>; Fri, 6 Nov 2009 12:11:35 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA6HBRPn026784
	for <video4linux-list@redhat.com>; Fri, 6 Nov 2009 12:11:31 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
	<Pine.LNX.4.64.0911032250060.5059@axis700.grange>
	<877hu6m5aq.fsf@free.fr>
	<Pine.LNX.4.64.0911052104430.5620@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 06 Nov 2009 18:11:16 +0100
In-Reply-To: <Pine.LNX.4.64.0911052104430.5620@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu\,
	5 Nov 2009 21\:37\:46 +0100 \(CET\)")
Message-ID: <87tyx7lgsr.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: Capturing video and still images using one driver
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> What this makes me think is that a sensor could provide several "contexts" of
>> use, as :
>>  - full resolution still image context
>>  - low resolution still image context
>>  - full resolution video context
>>  - low resolution video context
>
> Why fixed resolutions? Just make it possible to issue S_FMT for video or 
> for still imaging... That would work seamlessly with several inputs 
> (S_INPUT, S_FMT...).
It's not about _fixed_ resolution. It's rather about power consumption
actually. In mt9m111 sensor, there are 2 modes : A and B. Mode A always eats
tiny amounts of power, but the output resolution is limited to 640x480 IIRC.
Mode B eats more power, but allows full resolution of 1280x1024.

As I saw it, a "context" would allow a range of resolution, a range of clock,
and maybe capability to capture a video stream or not.

What's behind the concept of "context" is : a set of capabilities the hardware
can store internally (in terms of resolution, type of output, power consumption,
etc ...). And of course a "hardware switch" to switch between setups.

>> Then, a new/existing v4l2 call would switch the context (perhaps based on buffer
>> type ?) of the sensor.
>
> ...on a second thought, it doesn't seem that smart to me any more to tie 
> the streaming vs. still mode distinction to a specific buffer type...
I truly don't know. I'll take your word for it.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
