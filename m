Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57554 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932838AbbG1KRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 06:17:01 -0400
Message-ID: <55B75695.9050208@xs4all.nl>
Date: Tue, 28 Jul 2015 12:16:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/7] v4l2-fh: add v4l2_fh_open_is_first and v4l2_fh_release_is_last
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl> <1437733296-38198-4-git-send-email-hverkuil@xs4all.nl> <20150725224239.GA15270@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150725224239.GA15270@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/26/2015 12:42 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Jul 24, 2015 at 12:21:32PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add new helper functions that report back if this was the first open
>> or last close.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
> 
> ...
> 
>> @@ -65,11 +65,23 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
>>   */
>>  bool v4l2_fh_add(struct v4l2_fh *fh);
>>  /*
>> + * It allocates a v4l2_fh and inits and adds it to the video_device associated
>> + * with the file pointer. In addition it returns true if this was the first
>> + * open and false otherwise. The error code is returned in *err.
>> + */
>> +bool v4l2_fh_open_is_first(struct file *filp, int *err);
> 
> The new interface functions look a tad clumsy to me.
> 
> What would you think of returning the singularity value from v4l2_fh_open()
> straight away? Negative integers are errors, so zero and positive values are
> free.
> 
> A few drivers just check if the value is non-zero and then return that
> value, but there are just a handful of those.

I don't like messing with that. It can be done because all driver opens go through
either v4l2-dev.c or v4l2-subdev.c and we can convert a return value of >0 to 0. We
have to do that since fs/open.c doesn't check for >0, just != 0.

But that makes our 'open' implementation non-standard, and I feel that that's
both confusing and increases the chances of future bugs (precisely because it is
unexpected).

In pretty much all open() implementations of drivers you will have a 'int err;'
variable or something similar, so being able to do:

	if (v4l2_fh_open_is_first(file, &err)) {
	}

is actually quite efficient (see patch 7/7).

Regards,

	Hans
