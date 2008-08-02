Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72NcusM020589
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 19:38:56 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72NciES010722
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 19:38:44 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 03 Aug 2008 01:38:42 +0200
In-Reply-To: <Pine.LNX.4.64.0808022146090.27474@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat\,
	2 Aug 2008 22\:09\:50 +0200 \(CEST\)")
Message-ID: <873alnt2bh.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] soc_camera: endianness between camera and its host
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

> On Sat, 2 Aug 2008, Robert Jarzmik wrote:
>
>> Modern camera chips provide ways to invert their data output, as well in colors
>> swap as in byte order. To be more precise, the one I know (mt9m111) enables :
>
> To me these look like just different pixel formats:
Ah, they look like, but there aren't.

Let me explain the subtle part of it by an example on mio a701 phone :
 - mt9m111 is connected to a pxa272 cpu through an 8bit bus
 - when I select RGB565 as a pixel format, the pxa cpu expects the bits in a
 very precise order :
   - have a look at PXA Developper Manual, chapter 27.4.5.2.1, table 27-10. The
   order the bytes are comming on the bus is important, because of the
   "interpretation" the PXA does, to reorder and store them in memory.
   => the chip must send the bytes in that order
   - if you pay attention closely, you'll notice the pxa doesn't expect RGB but
   inverted BGR.
   - have a look at Micron MT9M111 specification, table 5, page 14. You'll see
   what they consider as RGB565.

>>  - swapping first and second byte in RGB formats
>
> hm, no idea about this one
Explanation above. Have a look at the 2 specification, and the tables I
mentionned. It will be far more clearer.

> So, I don't see at first any relation to host's endianness. You just 
> define respective formats in cameras array of struct 
> soc_camera_data_format.
That would be true if the host didn't interpret and reorder the bytes, which pxa
does.

> Isn't using the existing pixel format negotiation procedure eough?
If you still think that after looking at the tables, well .. we'll discuss
further. Maybe there's something I don't see ... You tell me your opinion once
you had looked at the tables.

You have all my code now, so you know what I'm facing here :)

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
