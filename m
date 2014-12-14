Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbaLNJte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 04:49:34 -0500
Message-ID: <548D5D26.5080504@redhat.com>
Date: Sun, 14 Dec 2014 10:49:26 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: LibV4L2 and CREATE_BUFS issues
References: <5488748B.7060703@collabora.com> <548C17C9.2060809@redhat.com> <548C6607.10700@collabora.com>
In-Reply-To: <548C6607.10700@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 13-12-14 17:15, Nicolas Dufresne wrote:
>
> Le 2014-12-13 05:41, Hans de Goede a écrit :
>> I think making CREATE_BUFS fail when doing conversion is probably best,
>> note that gstreamer should be able to tell which formats will lead to doing
>> conversion, and that it can try to avoid those.
>
> Those format indeed have a flag. The problem is for HW specific format, like few bayers format, which we can't avoid if we need to use such camera.

Ah yes I see, so I assume that if libv4l where to return a failure for
CREATE_BUFS when conversion is used, that gstreamer will then fallback to
a regular REQUEST_BUFS call ?

Then that indeed seems the best solution, can you submit patch for this ?

Regards,

Hans
