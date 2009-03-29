Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58229 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZC2A4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 20:56:41 -0400
Subject: Re: read() behavior
From: Andy Walls <awalls@radix.net>
To: Steve@Emel-Harrington.net
Cc: linux-media@vger.kernel.org
In-Reply-To: <1238281245.2166.11.camel@localhost.localdomain>
References: <1238281245.2166.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 20:57:06 -0400
Message-Id: <1238288226.3235.32.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-03-28 at 16:00 -0700, Steve Harrington wrote: 
> In general read(2) is not guaranteed to return a complete record.

Especially in non-blocking I/O mode.

>   For
> section reads from the demux device the amount of data returned will
> almost certainly be less than requested. I've never seen a section
> longer than a single TS packet and the recommended length for a read is
> 4096 bytes.

> The questions: are the v4l-dvb drivers guaranteed to return
> a complete section for each read?

Well, the spec says it *tries* to return 1 whole one.

>From the Linux DVB API spec, Section 3.2.3 read() (from the demux):

"When returning section data the driver always tries to return a complete single
section (even though buf would provide buffer space for more data). If the size
of the buffer is smaller than the section as much as possible will be returned,
and the remaining data will be provided in subsequent calls.
The size of the internal buffer is 2 * 4096 bytes (the size of two maximum
sized sections) by default."


>   If not, is there a preferred method
> to reassemble split sections?


1. Open the device node in non-blocking IO mode.

2. In a loop select() or poll() for when the device has data available.
It may be prudent to set a timeout here, so your program won't hang
forever, if something goes wrong.

3. Read() as much data as you can or care to read, when the device is
ready.  Don't forget trap error conditions: select() timed out, select()
was interrupted, read() was interrupted, read() was at the
end-of-file/stream, or all the other wonderful errno's on the read() man
page.

4. Shovel the data somewhere, keeping track of the bytes you've read in.
(buffer management happens here in your program)

5. Call a function to check if you have enough bytes to do something
useful (i.e. a section's worth).

6. If you've got enough bytes to do something useful, call the function
to drain off some of the bytes you've captured and do something useful
with the bytes.  (buffer management happens here in your program)

7. Go back to the beginning of the loop (#2) or check some exit
condition that you care about and drop out of the loop.


Nothing sepcial; just textbook, single-threaded, Unix.

Regards,
Andy

