Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45809 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbaLFMFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 07:05:25 -0500
Message-ID: <5482F0FC.4070104@xs4all.nl>
Date: Sat, 06 Dec 2014 13:05:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, aviv.d.greenberg@intel.com
Subject: Re: [REVIEW PATCH 1/2] v4l: Add data_offset to struct v4l2_buffer
References: <1417605249-5322-1-git-send-email-sakari.ailus@iki.fi> <1417605249-5322-2-git-send-email-sakari.ailus@iki.fi> <5481CACD.5060008@xs4all.nl> <20141206114849.GB15559@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141206114849.GB15559@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 12:48 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Dec 05, 2014 at 04:10:05PM +0100, Hans Verkuil wrote:
>> On 12/03/2014 12:14 PM, Sakari Ailus wrote:
>>> From: Sakari Ailus <sakari.ailus@linux.intel.com>

<snip>

>> I think we need to add new helper functions that give back the real plane size
>> (i.e. bytesused - data_offset) and the actual plane start position (plane start
>> + data_offset). It will be a bit tricky though to check existing drivers.
> 
> I think this mostly applies to OUTPUT buffers.
> 
> I find the definition for multi-plane buffers a little bit odd --- why not
> allow setting this for CAPTURE buffers as well, on hardware that supports
> it? This makes sense, in order to use the buffers on other interfaces
> without memory copies this may be even mandatory.

It's meant for drivers that have a header before the actual image (e.g. sensor
metadata passed on before the image). Userspace has no control over that, so
that's why it is set by the driver at capture time.

> 
> I wonder if we should change the spec regarding this, even if no driver
> support was added yet.

I don't think so. There is a good and clear reason for this.

> 
>> AFAICT vivid is one driver that uses vb2_plane_size() to check if enough space
>> is available for the image, but that doesn't take the data_offset into account.
>>
>> I suspect that similar problems occur for output drivers. And what isn't properly
>> defined at the moment is what should happen if an output driver doesn't support
>> a particular data_offset value.
>>
>> I think the only thing you can do in that case is to return an error when QBUF
>> is called.
> 
> I'd think so. Same for PREPARE_BUF.
> 
> I suppose very few drivers support this at the moment, and the ones that
> don't would return -EINVAL on QBUF. This could reveal broken user space
> applications. An alternative would be to silently assign a valid value to
> the field, but I'm not sure if that's any better.

I wouldn't do that. In my opinion it is a clear error.

Regards,

	Hans

