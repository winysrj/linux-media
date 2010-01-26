Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:60571 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550Ab0AZKKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 05:10:24 -0500
From: Arnaud Patard <apatard@mandriva.com>
To: Stefan Kost <ensonic@hora-obscura.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix VIDIOC_QBUF compat ioctl32
References: <m3bpgi448o.fsf@anduin.mandriva.com>
	<4B5E9FFD.2020708@hora-obscura.de>
Date: Tue, 26 Jan 2010 11:11:01 +0100
In-Reply-To: <4B5E9FFD.2020708@hora-obscura.de> (Stefan Kost's message of "Tue, 26 Jan 2010 09:55:41 +0200")
Message-ID: <m37hr541my.fsf@anduin.mandriva.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Kost <ensonic@hora-obscura.de> writes:

Hi,

> Arnaud Patard wrote:
>> When using VIDIOC_QBUF with memory type set to V4L2_MEMORY_MMAP, the
>> v4l2_buffer buffer gets unmodified on drivers like uvc (well, only
>> bytesused field is modified). Then some apps like gstreamer are reusing
>> the same buffer later to call munmap (eg passing the buffer "length"
>> field as 2nd parameter of munmap).
>>
>> It's working fine on full 32bits but on 32bits systems with 64bit
>> kernel, the get_v4l2_buffer32() doesn't copy length/m.offset values and
>> then copy garbage to userspace in put_v4l2_buffer32().
>>
>> This has for consequence things like that in the libv4l2 logs:
>>
>> libv4l2: v4l2 unknown munmap 0x2e2b0000, -2145144908
>> libv4l2: v4l2 unknown munmap 0x2e530000, -2145144908
>>
>> The buffer are not unmap'ed and then if the application close and open
>> again the device, it won't work and logs will show something like:
>>
>> libv4l2: error setting pixformat: Device or resource busy
>>
>> The easy solution is to read length and m.offset in get_v4l2_buffer32().
>>
>>
>> Signed-off-by: Arnaud Patard <apatard@mandriva.com>
>> ---
>>   
> I am not sure it even works fine on 32bit. Just yesterday I discovered
> https://bugzilla.gnome.org/show_bug.cgi?id=608042

My test app (cheese) is working on the 2 differents 32bits systems I
tried and with this patch it's working on my system, so it's possible
that your problem is different. Do you get this bug with cheese too ?

>
> I get this when using gstreamer with my UVC based camera
>
> request == VIDIOC_STREAMOFF
> result == 0
> libv4l2: v4l2 unknown munmap 0xb6d45000, 38400
> libv4l2: v4l2 unknown munmap 0xb6d3b000, 38400
>
> I verified that buffer address and size is correct. The libv4l code for 
> v4l2_munmap could be a bit more verbose in the case of an error ...

iirc, libv4l2 is telling you "unknown munmap" is a result of getting a
mmap call handled by the driver and not by libv4l2 (the size of your
buffer is 38400 and libv4l2 wants/expects the size to be 16777216 to
handle it). fwiw, I'm getting "unknown munmap" but that doesn't prevent
me to change the resolution in cheese.

Arnaud
