Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56853 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbaKQIst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 03:48:49 -0500
Message-ID: <5469B664.3050309@xs4all.nl>
Date: Mon, 17 Nov 2014 09:48:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 06/11] videodev2.h: add new v4l2_ext_control flags
 field
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl> <20141115141858.GG8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141115141858.GG8907@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2014 03:18 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Sun, Sep 21, 2014 at 04:48:24PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Replace reserved2 by a flags field. This is used to tell whether
>> setting a new store value is applied only once or every time that
>> v4l2_ctrl_apply_store() is called for that store.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/uapi/linux/videodev2.h | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 2ca44ed..fa84070 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1282,7 +1282,7 @@ struct v4l2_control {
>>  struct v4l2_ext_control {
>>  	__u32 id;
>>  	__u32 size;
>> -	__u32 reserved2[1];
>> +	__u32 flags;
> 
> 16 bits, please.

Good idea.

> The pad number (for sub-devices) would need to be added
> here as well,

Why? We never needed that for subdevs in the past. Not that I am against
reserving space for it, I'm just wondering if you have something specific
in mind.

> and that's 16 bits. A flag might be needed to tell it's valid,
> too.

Regards,

	Hans

