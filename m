Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36484 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaLNOYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 09:24:24 -0500
Message-ID: <548D9D93.1080301@collabora.com>
Date: Sun, 14 Dec 2014 09:24:19 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: LibV4L2 and CREATE_BUFS issues
References: <5488748B.7060703@collabora.com> <548C17C9.2060809@redhat.com> <548C6607.10700@collabora.com> <548D5D26.5080504@redhat.com>
In-Reply-To: <548D5D26.5080504@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-12-14 04:49, Hans de Goede a écrit :
> Ah yes I see, so I assume that if libv4l where to return a failure for
> CREATE_BUFS when conversion is used, that gstreamer will then fallback to
> a regular REQUEST_BUFS call ?
>
> Then that indeed seems the best solution, can you submit patch for this ? 

Exactly, that should work. My concern with application side workaround 
would that the day someone implements CREATE_BUF support in v4l2 this 
application won't benefit without patching. I'll see if I can find time, 
disabling it seems faster then implementing support for it, specially 
that current experiment show that the jpeg code is really fragile. 
Current state is that libv4l2 is causing a buffer overflow, so it is 
harmful library in that sense.

This raise a concern, it would mean that USERPTR, DMABUF, CREATE_BUFS 
will now be lost (in most cases) when enabling libv4l2. This is getting 
a bit annoying. Specially that we are pushing forward having m2m 
decoders to only be usable through libv4l2 (HW specific parsers). Is 
there a long term plan or are we simply pushing the dust toward libv4l2 ?

cheers,
Nicolas

