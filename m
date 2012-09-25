Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58775 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2IYOsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 10:48:02 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAW0049XUGMTO00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 15:48:22 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MAW00B6RUG09T70@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 15:48:01 +0100 (BST)
Message-id: <5061C41F.6080100@samsung.com>
Date: Tue, 25 Sep 2012 16:47:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [PATCH RFC 2/5] V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc
 definition
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
 <1348498546-2652-3-git-send-email-s.nawrocki@samsung.com>
 <2113003.Cq6nRq7Zuu@avalon>
In-reply-to: <2113003.Cq6nRq7Zuu@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/25/2012 01:44 PM, Laurent Pinchart wrote:
>> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
>> b/Documentation/DocBook/media/v4l/pixfmt.xml index 1ddbfab..9caed9b 100644
>> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
>> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
>> @@ -996,6 +996,15 @@ the other bits are set to 0.</entry>
>>  	    <entry>Old 6-bit greyscale format. Only the most significant 6 bits 
> of
>> each byte are used, the other bits are set to 0.</entry>
>>  	  </row>
>> +	  <row id="V4L2-PIX-FMT-JPG-YUYV-S5C">
>> +	    <entry><constant>V4L2_PIX_FMT_S5C_YUYV_JPG</constant></entry>
>> +	    <entry>'S5CJ'</entry>
>> +	    <entry>Two-planar format used by Samsung S5C73MX cameras.The first
>> +plane contains interleaved JPEG and YUYV data, followed by meta data
>> describing +layout of the YUYV and JPEG data blocks. The second plane
>> contains additional +information about data layout in the first plane, like
>> an offset to the array +of offsets to YUVY data chunks.</entry>
>> +	  </row>
> 
> I think you need to be a bit more precise here. You should document the format 
> of the meta data, as that's required for applications to use the format.

Right, I wasn't sure how detailed this DocBook description should be.
I thought about adding more detailed explanation of this format under
Documentation/video4linux/, but it probably makes more sense to add
a few more sentences here and make it complete and really useful.
Let me correct that in the next iteration.


Regards,
Sylwester
