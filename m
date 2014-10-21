Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27579 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaJUHRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 03:17:05 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDS006DG9P5XV50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Oct 2014 08:19:53 +0100 (BST)
Message-id: <5446086C.5030705@samsung.com>
Date: Tue, 21 Oct 2014 09:17:00 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v2 1/4] Add a media device configuration file parser.
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
 <1413557682-20535-2-git-send-email-j.anaszewski@samsung.com>
 <20141020214415.GE15257@valkosipuli.retiisi.org.uk>
In-reply-to: <20141020214415.GE15257@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/20/2014 11:44 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Oct 17, 2014 at 04:54:39PM +0200, Jacek Anaszewski wrote:
>> This patch adds a parser for a media device configuration
>> file. The parser expects the configuration file containing
>> links end v4l2-controls definitions as described in the
>> header file being added. The links describe connections
>> between media entities and v4l2-controls define the target
>> sub-devices for particular user controls related ioctl calls.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   lib/include/libv4l2-media-conf-parser.h |  148 +++++++++++
>>   lib/libv4l2/libv4l2-media-conf-parser.c |  441 +++++++++++++++++++++++++++++++
>>   2 files changed, 589 insertions(+)
>>   create mode 100644 lib/include/libv4l2-media-conf-parser.h
>>   create mode 100644 lib/libv4l2/libv4l2-media-conf-parser.c
>>
>> diff --git a/lib/include/libv4l2-media-conf-parser.h b/lib/include/libv4l2-media-conf-parser.h
>> new file mode 100644
>> index 0000000..b2dba3a
>> --- /dev/null
>> +++ b/lib/include/libv4l2-media-conf-parser.h
>> @@ -0,0 +1,148 @@
>> +/*
>> + * Parser of media device configuration file.
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *              http://www.samsung.com
>> + *
>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * The configuration file has to comply with following format:
>> + *
>> + * Link description entry format:
>> + *
>> + * link {
>> + * <TAB>source_entity: <entity_name><LF>
>> + * <TAB>source_pad: <pad_id><LF>
>> + * <TAB>sink_entity: <entity_name><LF>
>> + * <TAB>sink_pad: <pad_id><LF>
>> + * }
>
> Could you use the existing libmediactl format? The parser exists as well.

Of course, I will switch to using it.

> As a matter of fact, I have a few patches to make it easier to user in a
> library.
>
> libmediactl appears to be located under utils/media-ctl. Perhaps it's be
> better placed under lib. Cc Laurent.
>
>> + * The V4L2 control group format:
>> + *
>> + * v4l2-controls {
>> + * <TAB><control1_name>: <entity_name><LF>
>> + * <TAB><control2_name>: <entity_name><LF>
>> + * ...
>> + * <TAB><controlN_name>: <entity_name><LF>
>> + * }
>
> I didn't know you were working on this.

Actually I did the main part of work around 1,5 year ago as a part
of familiarizing myself with V4L2 media controller API.

>
> I have a small library which does essentially the same. The implementation
> is incomplete, that's why I hadn't posted it to the list. We could perhaps
> discuss this a little bit tomorrow. When would you be available, in case you
> are?

I will be available around 8 hours from now on.

> What would you think of using a little bit more condensed format for this,
> similar to that of libmediactl?
>

Could you spot a place where the format is defined?

Best Regards,
Jacek Anaszewski

