Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25294 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3JCCRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 22:17:06 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MU200DITMCE6C40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Oct 2013 03:17:02 +0100 (BST)
Message-id: <524CD39B.9020400@samsung.com>
Date: Thu, 03 Oct 2013 11:16:59 +0900
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com
Subject: Re: [PATCH v2 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
References: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi>
 <1380755873-25835-2-git-send-email-sakari.ailus@iki.fi>
 <5005169.gE657Xh6K1@avalon>
In-reply-to: <5005169.gE657Xh6K1@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/03/2013 08:29 AM, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 03 October 2013 02:17:50 Sakari Ailus wrote:
>> Pads that set this flag must be connected by an active link for the entity
>> to stream.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Looks good, I would just like to ask for changing my e-mail address on those
patches to s.nawrocki@samsung.com, sorry for not mentioning it earlier. 
Just one doubt below regarding name of the flag.

>> ---
>>  Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |   10 ++++++++++
>>  include/uapi/linux/media.h                               |    1 +
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
>> b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml index
>> 355df43..e357dc9 100644
>> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
>> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
>> @@ -134,6 +134,16 @@
>>  	    <entry>Output pad, relative to the entity. Output pads source data
>>  	    and are origins of links.</entry>
>>  	  </row>
>> +	  <row>
>> +	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
>> +	    <entry>If this flag is set and the pad is linked to any other
>> +	    pad, then at least one of those links must be enabled for the
>> +	    entity to be able to stream. There could be temporary reasons
>> +	    (e.g. device configuration dependent) for the pad to need
>> +	    enabled links even when this flag isn't set; the absence of the
>> +	    flag doesn't imply there is none. The flag has no effect on pads
>> +	    without connected links.</entry>

Probably MEDIA_PAD_FL_MUST_CONNECT name is fine, but isn't it more something
like MEDIA_PAD_FL_NEED_ACTIVE_LINK ? Or presumably MEDIA_PAD_FL_MUST_CONNECT
just doesn't make sense on pads without connected links and should never be
set on such pads ? From the last sentence it feels the situation where a pad
without a connected link has this flags set is allowed and a valid 
configuration.

Perhaps the last sentence should be something like:

"The flag should not be used on pads without connected links and has no effect
on such pads." 

Regards,
Sylwester

>> +	  </row>
>>  	</tbody>
>>        </tgroup>
>>      </table>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index ed49574..d847c76 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -98,6 +98,7 @@ struct media_entity_desc {
>>
>>  #define MEDIA_PAD_FL_SINK		(1 << 0)
>>  #define MEDIA_PAD_FL_SOURCE		(1 << 1)
>> +#define MEDIA_PAD_FL_MUST_CONNECT	(1 << 2)
>>
>>  struct media_pad_desc {
>>  	__u32 entity;		/* entity ID */


-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
