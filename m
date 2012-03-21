Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35820 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965129Ab2CUJxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 05:53:49 -0400
Message-ID: <4F69A52B.7070701@iki.fi>
Date: Wed, 21 Mar 2012 11:53:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 14/35] v4l: Add DPCM compressed raw bayer pixel formats
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-14-git-send-email-sakari.ailus@iki.fi> <CA+V-a8uNqKERJd-vvBCw0GLgDuFcC_5seXZ9pdf_eN1xyC_xZA@mail.gmail.com>
In-Reply-To: <CA+V-a8uNqKERJd-vvBCw0GLgDuFcC_5seXZ9pdf_eN1xyC_xZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Prabhakar Lad wrote:
> On Tue, Mar 6, 2012 at 10:02 PM, Sakari Ailus<sakari.ailus@iki.fi>  wrote:
...
>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
>> b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
>> new file mode 100644
>> index 0000000..80937f1
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
>> @@ -0,0 +1,29 @@
>> +<refentry>
>> +<refmeta>
>> +<refentrytitle>
>> +        V4L2_PIX_FMT_SRGGB10DPCM8 ('bBA8'),
>> +        V4L2_PIX_FMT_SGBRG10DPCM8 ('bGA8'),
>> +        V4L2_PIX_FMT_SGRBG10DPCM8 ('BD10'),
>> +        V4L2_PIX_FMT_SBGGR10DPCM8 ('bRA8'),
>> +</refentrytitle>
>
> You missed here to change as per the 4CC code documentation.

Thanks!

-- 
Sakari Ailus
sakari.ailus@iki.fi
