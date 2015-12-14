Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:33842 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbbLNOmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 09:42:00 -0500
Subject: Re: [Patch v5 1/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture
 driver
To: Benoit Parrot <bparrot@ti.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1447879632-22635-1-git-send-email-bparrot@ti.com>
 <1447879632-22635-2-git-send-email-bparrot@ti.com>
 <20151203111922.7b9bb226@recife.lan> <20151211221633.GF1517@ti.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <566ED532.6060308@xs4all.nl>
Date: Mon, 14 Dec 2015 15:41:54 +0100
MIME-Version: 1.0
In-Reply-To: <20151211221633.GF1517@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/2015 11:16 PM, Benoit Parrot wrote:
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote on Thu [2015-Dec-03 11:19:22 -0200]:
>>> +static int cal_enum_framesizes(struct file *file, void *fh,
>>> +			       struct v4l2_frmsizeenum *fsize)
>>> +{
>>> +	struct cal_ctx *ctx = video_drvdata(file);
>>> +	const struct cal_fmt *fmt;
>>> +	struct v4l2_subdev_frame_size_enum fse;
>>> +	int ret;
>>> +
>>> +	ctx_dbg(2, ctx, "%s\n", __func__);
>>
>> This s a general note: do you really need tracing-like debug macros
>> all around the code?
>>
>> You could easily check if the functions are called via trace.
> 
> True but that also mean to rebuild the kernel in order to
> get to it since function tracing is usually not enabled
> by default.
> 

You can enable debugging by doing:

echo 2 >/sys/class/video4linux/video0/dev_debug

See also: Documentation/video4linux/v4l2-framework.txt, section "video device
debugging" for more info.

That's always available and basically does what you want.

Regards,

	Hans

