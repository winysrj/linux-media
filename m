Return-path: <linux-media-owner@vger.kernel.org>
Received: from 213-133-109-209.clients.your-server.de ([213.133.109.209]:37425
	"EHLO smtp.hora-obscura.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab0AZIEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 03:04:40 -0500
Message-ID: <4B5E9FFD.2020708@hora-obscura.de>
Date: Tue, 26 Jan 2010 09:55:41 +0200
From: Stefan Kost <ensonic@hora-obscura.de>
MIME-Version: 1.0
To: Arnaud Patard <apatard@mandriva.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix VIDIOC_QBUF compat ioctl32
References: <m3bpgi448o.fsf@anduin.mandriva.com>
In-Reply-To: <m3bpgi448o.fsf@anduin.mandriva.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnaud Patard wrote:
> When using VIDIOC_QBUF with memory type set to V4L2_MEMORY_MMAP, the
> v4l2_buffer buffer gets unmodified on drivers like uvc (well, only
> bytesused field is modified). Then some apps like gstreamer are reusing
> the same buffer later to call munmap (eg passing the buffer "length"
> field as 2nd parameter of munmap).
>
> It's working fine on full 32bits but on 32bits systems with 64bit
> kernel, the get_v4l2_buffer32() doesn't copy length/m.offset values and
> then copy garbage to userspace in put_v4l2_buffer32().
>
> This has for consequence things like that in the libv4l2 logs:
>
> libv4l2: v4l2 unknown munmap 0x2e2b0000, -2145144908
> libv4l2: v4l2 unknown munmap 0x2e530000, -2145144908
>
> The buffer are not unmap'ed and then if the application close and open
> again the device, it won't work and logs will show something like:
>
> libv4l2: error setting pixformat: Device or resource busy
>
> The easy solution is to read length and m.offset in get_v4l2_buffer32().
>
>
> Signed-off-by: Arnaud Patard <apatard@mandriva.com>
> ---
>   
I am not sure it even works fine on 32bit. Just yesterday I discovered
https://bugzilla.gnome.org/show_bug.cgi?id=608042

I get this when using gstreamer with my UVC based camera

request == VIDIOC_STREAMOFF
result == 0
libv4l2: v4l2 unknown munmap 0xb6d45000, 38400
libv4l2: v4l2 unknown munmap 0xb6d3b000, 38400

I verified that buffer address and size is correct. The libv4l code for 
v4l2_munmap could be a bit more verbose in the case of an error ...

Stefan


