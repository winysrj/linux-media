Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:47504 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753491AbcFTLxd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 07:53:33 -0400
Subject: Re: [PATCH v4 1/9] [media] Add signed 16-bit pixel format
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-2-git-send-email-nick.dyer@itdev.co.uk>
 <5767CCB0.3060303@xs4all.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <20a8b8a3-1b90-9f7d-1dfa-c4f8168546d6@itdev.co.uk>
Date: Mon, 20 Jun 2016 12:51:25 +0100
MIME-Version: 1.0
In-Reply-To: <5767CCB0.3060303@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans-

On 20/06/2016 12:00, Hans Verkuil wrote:
> On 06/17/2016 04:16 PM, Nick Dyer wrote:
>> This will be used for output of raw touch delta data. This format is
>> used by Atmel maXTouch (atmel_mxt_ts) and also Synaptics RMI4.
>>
>> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
>> ---
>>  Documentation/DocBook/media/v4l/pixfmt-ys16.xml | 79 +++++++++++++++++++++++++
>>  Documentation/DocBook/media/v4l/pixfmt.xml      |  1 +
>>  drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
>>  include/uapi/linux/videodev2.h                  |  1 +
>>  4 files changed, 82 insertions(+)
>>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-ys16.xml
>>
>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-ys16.xml b/Documentation/DocBook/media/v4l/pixfmt-ys16.xml
>> new file mode 100644
>> index 0000000..f92d65e
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/pixfmt-ys16.xml
>> @@ -0,0 +1,79 @@
>> +<refentry id="V4L2-PIX-FMT-YS16">
>> +  <refmeta>
>> +    <refentrytitle>V4L2_PIX_FMT_YS16 ('YS16')</refentrytitle>
>> +    &manvol;
>> +  </refmeta>
>> +  <refnamediv>
>> +    <refname><constant>V4L2_PIX_FMT_YS16</constant></refname>
>> +    <refpurpose>Grey-scale image</refpurpose>
>> +  </refnamediv>
>> +  <refsect1>
>> +    <title>Description</title>
>> +
>> +    <para>This is a signed grey-scale image with a depth of 16 bits per
>> +pixel. The most significant byte is stored at higher memory addresses
>> +(little-endian).</para>
> 
> This is too generic. I think something like V4L2_TOUCH_FMT_DELTA_S16 is much
> more appropriate since this is neither luma (Y) data nor a picture in the
> classic sense. Since we already use V4L2_SDR_FMT_* defines for software defined
> radio formats, it makes sense to use V4L2_TOUCH_FMT_* for these touch panel
> formats.

OK, that sounds sensible to me.

> The description can be based around what you told here:
> 
> https://lkml.org/lkml/2016/5/27/278
> 
> It's also important that you clearly state what the delta is against. A delta
> implies a difference from something, but what that something is isn't explained.

To explain, in PCAP capacitive touch, a touch input is determined by
comparing the raw capacitance measurement to a no-touch reference (or
"baseline") measurement. Hence:

Delta = Raw - Reference

The reference measurement takes account of variations in the capacitance
characteristics across the nodes of the touch sensor, for example
manufacturing irregularities or edge effects.

I'll put something about this in the docs.

> I'm sorry for being pedantic about this, but it should be possible to make an
> application that can correctly interpret this data based on this format
> description. Otherwise there would be no point in documenting this...

No problem: thanks for your clear feedback.

