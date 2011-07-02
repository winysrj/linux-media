Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1GBJyw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 05:54:52 -0400
Message-ID: <4E0EEB43.9020703@redhat.com>
Date: Sat, 02 Jul 2011 11:56:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: V4L2_PIX_FMT_SE401: can support be removed from libv4lconvert.c?
References: <201107021141.20932.hverkuil@xs4all.nl>
In-Reply-To: <201107021141.20932.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 07/02/2011 11:41 AM, Hans Verkuil wrote:
> Hi Hans,
>
> V4L2_PIX_FMT_SE401 was removed in the latest videodev2.h. I assume that that
> code can also be removed from libv4lconvert.c?

If you look at the history you will see that support for it was actually
added to libv4lconvert recently. The reason for this is that together
with my pwc driver I also have a new se401 driver queued up in my local
tree :)

So V4L2_PIX_FMT_SE401 has not been removed from the latest videodev2.h,
it has not been added yet (I've queued up a separate patch for that).

So if you want to update the videodev2.h copy in v4l-utils, please
leave in the V4L2_PIX_FMT_SE401 define.

Thanks & Regards,

Hans
