Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:39227 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3JLLCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 07:02:46 -0400
Message-ID: <52592C52.20101@gmail.com>
Date: Sat, 12 Oct 2013 13:02:42 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	pawel@osciak.com, javier.martin@vista-silicon.com,
	m.szyprowski@samsung.com, shaik.ameer@samsung.com,
	arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 1/7] V4L: Add mem2mem ioctl and file operation helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com> <1379076986-10446-2-git-send-email-s.nawrocki@samsung.com> <5249474E.7010400@xs4all.nl>
In-Reply-To: <5249474E.7010400@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/2013 11:41 AM, Hans Verkuil wrote:
> On 09/13/2013 02:56 PM, Sylwester Nawrocki wrote:
>> This patch adds ioctl helpers to the V4L2 mem-to-mem API, so we
>> can avoid several ioctl handlers in the mem-to-mem video node
>> drivers that are simply a pass-through to the v4l2_m2m_* calls.
>> These helpers will only be useful for drivers that use same mutex
>> for both OUTPUT and CAPTURE queue, which is the case for all
>> currently in tree v4l2 m2m drivers.
>> In order to use the helpers the driver are required to use
>> struct v4l2_fh.
>
> Looks good! I have one small comment below that you might want to address,
> although it isn't blocking.
>
> Acked-by: Hans Verkuil<hans.verkuil@cisco.com>
>
> Regards,
>
> 	Hans
>
>> +/* Videobuf2 ioctl helpers */
>> +
>> +int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
>> +				struct v4l2_requestbuffers *rb)
>> +{
>> +	struct v4l2_fh *fh = file->private_data;
>
> I prefer an empty line after the variable declaration. Ditto below.

Thank you for the review. All right, I will include this change in next
iteration. Even though my feeling is that such two-liner functions look
better without an empty line and readability is still maintained.

--
Regards,
Sylwester
