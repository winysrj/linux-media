Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966327AbaLMKl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 05:41:27 -0500
Message-ID: <548C17C9.2060809@redhat.com>
Date: Sat, 13 Dec 2014 11:41:13 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: LibV4L2 and CREATE_BUFS issues
References: <5488748B.7060703@collabora.com>
In-Reply-To: <5488748B.7060703@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10-12-14 17:27, Nicolas Dufresne wrote:
> Hi,
>
> we recently fixed our CREATE_BUFS support in GStreamer master. It works
> nicely with UVC drivers. The problem is that libv4l2 isn't aware of it,
> and endup taking terribly decision the least quickly lead to crash.
>
> I'm not sure what that right approach. It seems non-trivial to support
> it, at least it would require a bit more knowledge of the converter code
> and memory model. Maybe we should at least make sure that CREATE_BUF
> fails if we are doing conversion ? Some input on that would be appreciated.

I think making CREATE_BUFS fail when doing conversion is probably best,
note that gstreamer should be able to tell which formats will lead to doing
conversion, and that it can try to avoid those.

Regards,

Hans
