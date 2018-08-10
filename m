Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54554 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727450AbeHJJ5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 05:57:10 -0400
Subject: Re: [PATCHv17 03/34] media-request: implement media requests
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-4-hverkuil@xs4all.nl>
 <20180809153732.7701894c@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b38814c3-bc06-23d3-29c4-94e4a3c72d3c@xs4all.nl>
Date: Fri, 10 Aug 2018 09:28:28 +0200
MIME-Version: 1.0
In-Reply-To: <20180809153732.7701894c@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2018 08:37 PM, Mauro Carvalho Chehab wrote:
>> +	get_task_comm(comm, current);
>> +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
>> +		 comm, fd);
> 
> I'm pretty sure we've discussed about get_task_comm(). I don't think 
> we should use it, as the task with queues can be different than
> the one with dequeues. Instead, just give an unique ID for each
> request. That will allow tracking it in a better way, no matter how
> the userspace app is encoded.

The original discussion went back-and-forth a bit, but I'll just
replace it with a unique ID.

> Also, for dynamic debugs, the task ID can easily be obtained by
> passing a parameter to it, with +t:
> 
> 	echo "file media_request.c +t" > /sys/kernel/debug/dynamic_debug/control
> 
> or, at the boot time with:
> 	dyndbg="file media_request.c +t"
> 
> So, Kernel shouldn't be bothered by having such hacks hardcoded
> at the code.

Regards,

	Hans
