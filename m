Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbcFTPhw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:37:52 -0400
Subject: Re: [PATCH 3/6] v4l: Add packed Bayer raw12 pixel formats
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464353080-18300-4-git-send-email-sakari.ailus@linux.intel.com>
 <576809F1.1010507@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57680DCD.1000902@linux.intel.com>
Date: Mon, 20 Jun 2016 18:37:49 +0300
MIME-Version: 1.0
In-Reply-To: <576809F1.1010507@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review!

Hans Verkuil wrote:
> On 05/27/2016 02:44 PM, Sakari Ailus wrote:
>> These formats are compressed 12-bit raw bayer formats with four different
>> pixel orders. They are similar to 10-bit variants. The formats added by
>> this patch are
>>
>> 	V4L2_PIX_FMT_SBGGR12P
>> 	V4L2_PIX_FMT_SGBRG12P
>> 	V4L2_PIX_FMT_SGRBG12P
>> 	V4L2_PIX_FMT_SRGGB12P
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  .../DocBook/media/v4l/pixfmt-srggb12p.xml          | 103 +++++++++++++++++++++
>>  Documentation/DocBook/media/v4l/pixfmt.xml         |   1 +
>>  include/uapi/linux/videodev2.h                     |   5 +
>>  3 files changed, 109 insertions(+)
>>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml
>>
>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml
>> new file mode 100644
>> index 0000000..affa366
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml
>> @@ -0,0 +1,103 @@
>> +    <refentry id="pixfmt-srggb12p">
>> +      <refmeta>
>> +	<refentrytitle>V4L2_PIX_FMT_SRGGB12P ('pRCC'),
>> +	 V4L2_PIX_FMT_SGRBG12P ('pgCC'),
>> +	 V4L2_PIX_FMT_SGBRG12P ('pGCC'),
>> +	 V4L2_PIX_FMT_SBGGR12P ('pBCC'),
> 
> Nitpick: the last comma should be removed otherwise the title would end with it.
> 
> Looks good otherwise.
> 
> With the comma removed:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Indeed. Looks like this comes from the 10-bit definitions. I'll fix that
one as well.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
