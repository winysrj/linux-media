Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1HHHvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2011 03:51:14 -0400
Message-ID: <4E3F95DC.7090600@redhat.com>
Date: Mon, 08 Aug 2011 09:53:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk>
In-Reply-To: <201108072353.42237.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/08/2011 12:53 AM, Adam Baker wrote:
> On Friday 05 August 2011, Hans de Goede wrote:
>>> This sounds to be a good theme for the Workshop, or even to KS/2011.
>>
>> Agreed, although we don't need to talk about this for very long, the
>> solution is basically:
>> 1) Define a still image retrieval API for v4l2 devices (there is only 1
>>     interface for both functions on these devices, so only 1 driver, and to
>>     me it makes sense to extend the existing drivers to also do still image
>>     retrieval).
>> 2) Modify existing kernel v4l2 drivers to provide this API
>> 3) Write a new libgphoto driver which talks this interface (only need to
>>     do one driver since all dual mode cams will export the same API).
>>
>> 1) is something to discuss at the workshop.
>>
> This approach sounds fine as long as you can come up with a definition for the
> API that covers the existing needs and is extensible when new cameras come
> along and doesn't create horrible inefficiencies by not matching the way some
> cameras work. I've only got one example of such a camera and it is a fairly
> basic one but things I can imagine the API needing to provide are
>
> 1) Report number of images on device

Make that report highest picture number present call. We want to provide
consistent numbers for pictures even if some are deleted, renumbering them
on the fly when a picture gets deleted is no good, esp. since multiple
apps may be using the device at the same time. So we may have a hole in out
numbering, hence my initial proposal of having the following API:

int get_max_picture_nr()
int is_picture_present(int nr)
int get_picture(int nr)
int delete_picture(int nr)
int delete_all()

> 2) Select an image to read (for some cameras selecting next may be much more
> efficient than selecting at random although whether that inefficiency occurs
> when selecting, when reading image info or when reading image data may vary)
> 3) Read image information for selected image (resolution, compression type,
> FOURCC)

I have not yet thought about meta-data. But I agree we will need some metadata
to convey things like the format of the picture data returned by get_picture
(this will be raw data any conversion / post processing will be done in
  userspace).

> 4) Read raw image data for selected image
> 5) Delete individual image (not supported by all cameras)
> 6) Delete all images (sometimes supported on cameras that don't support
> individual delete)
>
> I'm not sure if any of these cameras support tethered capture but if they do
> then add
> Take photo
> Set resolution
>

That is what the webcam mode is for :)

> I doubt if any of them support EXIF data, thumbnail images, the ability to
> upload images to the camera or any sound recording but if they do then those
> are additional things that gphoto2 would want to be able to do.

sound recordings can be handled like pictures but with a different
FOURCC code (conveying the contents is audio stored in fmt foo).

Regards,

Hans
