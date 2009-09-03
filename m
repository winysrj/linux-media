Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:60584 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749AbZICJRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 05:17:32 -0400
Message-ID: <4A9F89AD.7030106@onelan.com>
Date: Thu, 03 Sep 2009 10:17:33 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl>
In-Reply-To: <4A9EAF07.3040303@hhs.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 09/02/2009 06:32 PM, Simon Farnsworth wrote:
>> I have a Hauppauge HVR1600 for NTSC and ATSC support, and it appears to
>> simply not work with libv4l2, due to lack of mmap support. My code works
>> adequately (modulo a nice pile of bugs) with a HVR1110r3, so it appears
>> to be driver level.
>>
>> Which is the better route to handling this; adding code to input_v4l to
>> use libv4lconvert when mmap isn't available, or converting the cx18
>> driver to use mmap?
>>
> 
> Or modify libv4l2 to also handle devices which can only do read. There have
> been some changes to libv4l2 recently which would make doing that feasible.
> 
Roughly what would I need to do to libv4l2?

I can see four new cases to handle:

1) driver supports read(), client wants read(), format supported by
both. Just pass read() through to the driver.

2) driver supports read(), client wants mmap(), format supported by
both. Allocate buffers when REQBUFs happens, handle QBUF and DQBUF by
read()ing frame size chunks into the buffer at the head of the internal
queue when a DQBUF happens, and passing it back out.

3) As 1, but needs conversion. read() into a temporary buffer, convert
with libv4lconvert (I think this needs a secondary buffer), and supply
data from the secondary buffer to read()

4) As 2, but needs conversion. Change DQBUF handling to read() frame
size chunks into a temporary buffer, then use libv4lconvert to copy
those chunks from the temporary buffer into the buffer you're about to
pass out.

Have I missed anything?

>> If it's a case of converting the cx18 driver, how would I go about doing
>> that? I have no experience of the driver, so I'm not sure what I'd have
>> to do - noting that if I break the existing read() support, other users
>> will get upset.
> 
> I don't believe that modifying the driver is the answer, we need to either
> fix this at the libv4l or xine level.
> 
> I wonder though, doesn't the cx18 offer any format that xine can handle
> directly?
> 
Not sensibly; it offers HM12 only, and Xine needs an RGB format, YV12,
or YUYV. With a lot of rework, I could have the cx18 encode video to
MPEG-2, then have Xine decode the resulting MPEG-2 stream, but this
seems like overkill for uncompressed video. I could also teach Xine to
handle HM12 natively, but that would duplicate effort already done in
libv4l2 and libv4lconvert, which seems a bit silly to me.
-- 
Simon Farnsworth

