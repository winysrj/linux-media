Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56538 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbcE0NSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 09:18:36 -0400
Subject: Re: [PATCH v2 2/8] [media] Add signed 16-bit pixel format
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
 <1462381638-7818-3-git-send-email-nick.dyer@itdev.co.uk>
 <57483FD1.9080704@xs4all.nl>
 <82b68931-0da1-bd26-87c1-1cd9e2296f71@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57484926.9040109@xs4all.nl>
Date: Fri, 27 May 2016 15:18:30 +0200
MIME-Version: 1.0
In-Reply-To: <82b68931-0da1-bd26-87c1-1cd9e2296f71@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2016 02:52 PM, Nick Dyer wrote:
> On 27/05/2016 13:38, Hans Verkuil wrote:
>> On 05/04/2016 07:07 PM, Nick Dyer wrote:
>>> +    <refname><constant>V4L2_PIX_FMT_YS16</constant></refname>
>>> +    <refpurpose>Grey-scale image</refpurpose>
>>> +  </refnamediv>
>>> +  <refsect1>
>>> +    <title>Description</title>
>>> +
>>> +    <para>This is a signed grey-scale image with a depth of 16 bits per
>>> +pixel. The most significant byte is stored at higher memory addresses
>>> +(little-endian).</para>
>>
>> I'm not sure this should be described in terms of grey-scale, since negative
>> values make no sense for that. How are these values supposed to be interpreted
>> if you want to display them? -32768 == black and 32767 is white?
> 
> We have written a utility to display this data and it is able to display
> the values mapped to grayscale or color:
> https://github.com/ndyer/heatmap/blob/master/src/display.c#L44
> 
> An example of the output is here:
> https://www.youtube.com/watch?v=Uj4T6fUCySw
> 
> The data is intrinsically signed because that's how the low level touch
> controller treats it. I'm happy to change it to "Signed image" if you think
> that would be better.

A V4L2_PIX_FMT_ definition must specify the format unambiguously. So it is not
enough to just say that the data is a signed 16 bit value, you need to document
exactly how it should be interpreted. Looking at the code it seems that the
signed values are within a certain range and are normalized to 0-max by this line:

ssize_t gray = (data[i] - cfg->min) * max / (cfg->max - cfg->min);

Are the min/max values defined by the hardware? Because in that case this pixel
format has to be a hardware-specific define (e.g. V4L2_PIX_FMT_FOO_S16).

Only if the min/max values are -32768 and 32767 can you really use YS16 (not sure
yet about that name, but that's another issue).

Regards,

	Hans
