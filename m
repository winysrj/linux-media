Return-path: <linux-media-owner@vger.kernel.org>
Received: from honeysuckle.london.02.net ([87.194.255.144]:54255 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1HGWxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 18:53:48 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Sun, 7 Aug 2011 23:53:41 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com>
In-Reply-To: <4E3B9597.4040307@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108072353.42237.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 05 August 2011, Hans de Goede wrote:
> > This sounds to be a good theme for the Workshop, or even to KS/2011.
> 
> Agreed, although we don't need to talk about this for very long, the
> solution is basically:
> 1) Define a still image retrieval API for v4l2 devices (there is only 1
>    interface for both functions on these devices, so only 1 driver, and to
>    me it makes sense to extend the existing drivers to also do still image
>    retrieval).
> 2) Modify existing kernel v4l2 drivers to provide this API
> 3) Write a new libgphoto driver which talks this interface (only need to
>    do one driver since all dual mode cams will export the same API).
> 
> 1) is something to discuss at the workshop.
> 
This approach sounds fine as long as you can come up with a definition for the 
API that covers the existing needs and is extensible when new cameras come 
along and doesn't create horrible inefficiencies by not matching the way some 
cameras work. I've only got one example of such a camera and it is a fairly 
basic one but things I can imagine the API needing to provide are

1) Report number of images on device
2) Select an image to read (for some cameras selecting next may be much more 
efficient than selecting at random although whether that inefficiency occurs 
when selecting, when reading image info or when reading image data may vary)
3) Read image information for selected image (resolution, compression type, 
FOURCC)
4) Read raw image data for selected image
5) Delete individual image (not supported by all cameras)
6) Delete all images (sometimes supported on cameras that don't support 
individual delete)

I'm not sure if any of these cameras support tethered capture but if they do 
then add
Take photo
Set resolution

I doubt if any of them support EXIF data, thumbnail images, the ability to 
upload images to the camera or any sound recording but if they do then those 
are additional things that gphoto2 would want to be able to do.

Regards

Adam
