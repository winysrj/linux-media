Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab1D0KN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 06:13:28 -0400
Message-ID: <4DB7EC8A.30409@redhat.com>
Date: Wed, 27 Apr 2011 12:14:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>
Subject: Re: [RFC, PATCH] libv4lconvert: Add support for Y10B grey format
 (V4L2_PIX_FMT_Y10BPACK)
References: <1302192989-7747-1-git-send-email-ospite@studenti.unina.it>	<4DA36D98.40607@redhat.com> <20110418122540.dbbe9b06.ospite@studenti.unina.it>
In-Reply-To: <20110418122540.dbbe9b06.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

sorry for being a bit slow ...

On 04/18/2011 12:25 PM, Antonio Ospite wrote:
> On Mon, 11 Apr 2011 23:07:36 +0200
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
> [...]
>>> I don't know libv4l yet, so I am asking for advice providing some code to
>>> discuss on; looking at the last hunk of the patch: can I allocate a temporary
>>> buffer only once per device (and not per frame as I am horribly doing now) and
>>> reuse it in the conversion routines?
>>
>> libv4l has a mechanism for doing this, you can "simply" do:
>>
>> unpacked_buffer = v4lconvert_alloc_buffer(width * height * sizeof(unsigned short),
>>                                             &data->convert_pixfmt_buf,
>>                                             &data->convert_pixfmt_buf_size);
>>
>> v4lconvert_alloc_buffer will remember the buffer (and its size) and return the
>> same buffer each call. Freeing it on closing of the device is also taken care
>> of. You should still check for a NULL return.
>>
>
> Thanks that works fine: I am still not sure I like passing
> 'v4l2convert_data' to the pixelformat conversion routines but we'll
> discuss that on the next review round.
>
>> What has me worried more, is how libv4l will decide between asking
>> Y10B grey versus raw bayer from the device when an app is asking for say RGB24.
>> libv4l normally does this automatically on a best match basis (together with
>> preferring compressed formats over uncompressed for high resolutions). But this
>> won't work in the kinect case. If we prioritize one over the other we will
>> always end up giving the app the one we prioritize.
>>
>
> Mmh, I tried to materialize your worries, these are the native modes
> supported:
>    - GRBG mode at 640x480 and 1280x1024
>    - UYVY mode ay 640x480
>    - Y10B mode at 640x488 and 1280x1024
>                         ^
>
> and this is the behavior I am observing in qv4l2 when in _wrapped_ mode:
>    - If I choose the RGB3 output format all the three different
>      resolutions are selectable:
>        + at 640x480 I get the color image, as there is no greyscale
>          format at the same resolution,
>        + at 640x488 I get the grayscale image, as there is no color
>          format at the same resolution,


>        + if I choose 1280x1024 I get the grayscale image indeed, and I
>          loose the possibility of using the color image.

We should be able to make it pick color there by simply putting
the Y10B format at the end of supported_src_pixfmts

I think once we do that, that we don't need to do anything special
here. Apps which really want the grey scale data should then just request
either 640x488 or even better probably directly select Y10B and deal with
it themselves.

>
> Everything works fine in _raw_ mode of course where only the native
> formats are shown.
>
> Ah, a strange thing (to me at least) happens in _wrapped_ mode even for
> GRBG (which is supposed to be a _native_ color format for the device):
> I get the grayscale image at 1280x1024 instead of the color image; can
> this just be a bug somewhere in qv4l2 or lib4vl?

Yeah that sounds like a bug
/me blames qv4l2
(always blame the other guy's code :)


>
>> The only thing I can think of is adding a v4l2 control (like a brightness
>> control) for choosing which format to prioritize...
>>
>
> and this control would be created by libv4l when in wrapped mode?

Yes, but that is an ugly UGLY hack, I don't think we will really need this,
see above.

Thanks,

Hans
