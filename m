Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab2L3JZl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Dec 2012 04:25:41 -0500
Message-ID: <50E00914.2090908@redhat.com>
Date: Sun, 30 Dec 2012 10:27:48 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT" recommendation
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com> <20121228222744.6b567a9b@redhat.com> <201212291253.45189.hverkuil@xs4all.nl> <20121229122334.00ea0b8a@redhat.com> <CAGoCfizjL=CozEwxPhvbHwBCHjYGS8VzNx1ewNHh2ebVzhVSVg@mail.gmail.com> <20121229183224.349c9cf3@redhat.com>
In-Reply-To: <20121229183224.349c9cf3@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/29/2012 09:32 PM, Mauro Carvalho Chehab wrote:

> Agreed. Adding YUYV support at libv4l should be easy.

Make that easy-ish. There is the easy and the hardway, the easy way
is to add an extra conversion step and then convert yuv420 to yuyv, but
TBH that is a stupid thing to do, it potentially looses video resolution
in the u and v planes and it is just not very cpu effective.

So the right thing to do is to go over all the rawXXX -> rgb + rawXXX ->
yuv420 converter function pairs, and add a rawXXX -> yuyv function to them
for all supported src formats.

<snip>

> Applications that use libv4l will do whatever behavior libv4l does.

libv4l has 3 different scenarios here:
1) The app is asking for a format libv4l does not support (iow not rgb24
or yuv420), and the video device only supports some proprietary format
(ie many gspca webcams), then libv4l will change the requested format to
RGB24, do a try_fmt to the device to get closest width/height and returns
that. So in this scenario it behaves as Hans V. has suggested.

2) The app is asking for a format libv4l does not support and the device
supports one or more standard formats, then libv4l simple passes
on the try_fmt to the device, and returns whatever it returns. This is
what will happen with most tv-cards, so using libv4l won't help here!

3) The app is asking for a format that libv4l does support, then libv4l
negotiates with the device to find the best src format to convert from.
libv4l's negotation code will check both the try_fmt return value, as
well as that the resulting format is what it asked for. So it does not
care either way...

Regards,

Hans
