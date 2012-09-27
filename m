Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2I0KZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 06:25:03 -0400
Message-ID: <506429D1.4090401@redhat.com>
Date: Thu, 27 Sep 2012 12:26:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: qv4l2-bug / libv4lconvert API issue
References: <50636DD2.3070508@googlemail.com>
In-Reply-To: <50636DD2.3070508@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/26/2012 11:04 PM, Frank Schäfer wrote:
> Hi,
>
> I've noticed the following issues/bugs while playing with qv4l:
> 1.) with pac7302-webcams, only the RGB3 (RGB24) format is working. BGR3,
> YU12 and YV12 are broken
> 2.) for upside-down-mounted devices with an entry in libv4lconvert,
> automatic h/v-flipping doesn't work with some formats
>
> I've been digging a bit deeper into the code and it seems that both
> issues are caused by a problem with the libv4lconvert-API:
> Besides image format conversion, function v4lconvert_convert() also does
> the automatic image flipping and rotation (for devices with flags
> V4LCONTROL_HFLIPPED, V4LCONTROL_VFLIPPED and V4LCONTROL_ROTATED_90_JPEG)
> The problem is, that this function can be called multiple times for the
> same frame, which then of course results in repeated flipping and
> rotation...
>
> And this is exactly what happens with qv4l2:
> qv4l2 gets the frame from libv4l2, which calls v4lconvert_convert() in
> v4l2_dequeue_and_convert() or v4l2_read_and_convert().
> The retrieved frame has the requested format and is already flipped/rotated.
> qv4l2 then calls v4lconvert_convert() again directly to convert the
> frame to RGB24 for GUI-output and this is where things are going wrong.
> In case of h/v-flip, the double conversion "only" equalizes the
> V4LCONTROL_HFLIPPED, V4LCONTROL_VFLIPPED flags, but for rotated devices,
> the image gets corrupted.
>
> Sure, what qv4l2 does is a crazy. Applications usually request the
> format needed for GUI-output directly from libv4l2.
> Anyway, as long as it is valid to call libv4lconvert directly, we can
> not assume that v4lconvert_convert() is called only one time.
>
> At the moment, I see no possibility to fix this without changing the
> libv4lconvert-API.
> Thoughts ?

What you've found is a qv4l2 bug (do you have the latest version?) one
is supposed to either use libv4l2, or do raw device access and then
call libv4lconvert directly. These are also the 2 modes qv4l2 has
(for testing purposes), it is not supposed to do the manual convert call
when using libv4l2 to access the device ...

Regards,

Hans
