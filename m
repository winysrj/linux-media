Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37369 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaKQImH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 03:42:07 -0500
Message-ID: <5469B4D0.4020205@xs4all.nl>
Date: Mon, 17 Nov 2014 09:41:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 03/11] videodev2.h: rename reserved2 to config_store
 in v4l2_buffer.
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-4-git-send-email-hverkuil@xs4all.nl> <20141114153505.GE8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141114153505.GE8907@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2014 04:35 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> One more comment...
> 
> On Sun, Sep 21, 2014 at 04:48:21PM +0200, Hans Verkuil wrote:
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 83ef28a..2ca44ed 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -672,6 +672,7 @@ struct v4l2_plane {
>>   * @length:	size in bytes of the buffer (NOT its payload) for single-plane
>>   *		buffers (when type != *_MPLANE); number of elements in the
>>   *		planes array for multi-plane buffers
>> + * @config_store: this buffer should use this configuration store
>>   *
>>   * Contains data exchanged by application and driver using one of the Streaming
>>   * I/O methods.
>> @@ -695,7 +696,7 @@ struct v4l2_buffer {
>>  		__s32		fd;
>>  	} m;
>>  	__u32			length;
>> -	__u32			reserved2;
>> +	__u32			config_store;
>>  	__u32			reserved;
>>  };
>>  
> 
> I would use __u16 instead since the value is 16-bit on the control
> interface.
> 

Good point. Will do.

	Hans
