Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45861 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbcFTQFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:05:53 -0400
Subject: Re: [PATCH 5/6] v4l: Add 14-bit raw bayer pixel format definitions
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464353080-18300-6-git-send-email-sakari.ailus@linux.intel.com>
 <57680ACB.3050109@xs4all.nl> <576813B9.9050407@linux.intel.com>
Cc: g.liakhovetski@gmx.de
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5768145B.2010306@xs4all.nl>
Date: Mon, 20 Jun 2016 18:05:47 +0200
MIME-Version: 1.0
In-Reply-To: <576813B9.9050407@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 06:03 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Hans Verkuil wrote:
>> On 05/27/2016 02:44 PM, Sakari Ailus wrote:
>>> The formats added by this patch are:
>>>
>>> 	V4L2_PIX_FMT_SBGGR14
>>> 	V4L2_PIX_FMT_SGBRG14
>>> 	V4L2_PIX_FMT_SGRBG14
>>> 	V4L2_PIX_FMT_SRGGB14
>>>
>>> Signed-off-by: Jouni Ukkonen <jouni.ukkonen@intel.com>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  Documentation/DocBook/media/v4l/pixfmt-srggb14.xml | 90 ++++++++++++++++++++++
>>>  Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
>>>  include/uapi/linux/videodev2.h                     |  4 +
>>>  3 files changed, 95 insertions(+)
>>>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb14.xml
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb14.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb14.xml
>>> new file mode 100644
>>> index 0000000..7e82d7e
>>> --- /dev/null
>>> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb14.xml
>>> @@ -0,0 +1,90 @@
>>> +    <refentry>
>>> +      <refmeta>
>>> +	<refentrytitle>V4L2_PIX_FMT_SRGGB14 ('RG14'),
>>> +	 V4L2_PIX_FMT_SGRBG14 ('BA14'),
>>> +	 V4L2_PIX_FMT_SGBRG14 ('GB14'),
>>> +	 V4L2_PIX_FMT_SBGGR14 ('BG14'),
>>
>> Same comma problem.
> 
> Fixed.
> 
>>
>>> +	 </refentrytitle>
>>> +	&manvol;
>>> +      </refmeta>
>>> +      <refnamediv>
>>> +	<refname id="V4L2-PIX-FMT-SRGGB14"><constant>V4L2_PIX_FMT_SRGGB14</constant></refname>
>>> +	<refname id="V4L2-PIX-FMT-SGRBG14"><constant>V4L2_PIX_FMT_SGRBG14</constant></refname>
>>> +	<refname id="V4L2-PIX-FMT-SGBRG14"><constant>V4L2_PIX_FMT_SGBRG14</constant></refname>
>>> +	<refname id="V4L2-PIX-FMT-SBGGR14"><constant>V4L2_PIX_FMT_SBGGR14</constant></refname>
>>> +	<refpurpose>14-bit Bayer formats expanded to 16 bits</refpurpose>
>>> +      </refnamediv>
>>> +      <refsect1>
>>> +	<title>Description</title>
>>> +
>>> +	<para>These four pixel formats are raw sRGB / Bayer formats with
>>> +14 bits per colour. Each colour component is stored in a 16-bit word, with 2
>>> +unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
>>> +and n/2 blue or red samples, with alternating red and blue rows. Bytes are
>>> +stored in memory in little endian order. They are conventionally described
>>> +as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
>>> +formats</para>
>>
>> s/formats/formats:/
> 
> Fixed.
> 
>>> +
>>> +    <example>
>>> +      <title><constant>V4L2_PIX_FMT_SBGGR14</constant> 4 &times; 4
>>> +pixel image</title>
>>> +
>>> +      <formalpara>
>>> +	<title>Byte Order.</title>
>>> +	<para>Each cell is one byte, high 2 bits in high bytes are 0.
>>
>> s/high 2/the high 2/
> 
> After re-reading the patch, I changed this to "Each cell is one byte,
> the 2 most significant bits in the high bytes are 0".

That is indeed better, although I would also say "two most" instead of "2 most".
It's slightly weird to have "one byte" followed by "2 most". Could be me, though.

Regards,

	Hans
