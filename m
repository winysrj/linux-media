Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41774 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbbHYGba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 02:31:30 -0400
Message-ID: <55DC0B91.2000204@xs4all.nl>
Date: Tue, 25 Aug 2015 08:30:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Bryan Wu <pengw@nvidia.com>, Thierry Reding <treding@nvidia.com>
CC: hansverk@cisco.com, linux-media@vger.kernel.org,
	ebrower@nvidia.com, jbang@nvidia.com, swarren@nvidia.com,
	wenjiaz@nvidia.com, davidw@nvidia.com, gfitzer@nvidia.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com> <1440118300-32491-5-git-send-email-pengw@nvidia.com> <20150821130339.GB22118@ulmo.nvidia.com> <55DBB62C.4020606@nvidia.com>
In-Reply-To: <55DBB62C.4020606@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A quick follow-up to Thierry's excellent review:

On 08/25/2015 02:26 AM, Bryan Wu wrote:
> On 08/21/2015 06:03 AM, Thierry Reding wrote:
>> On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:

<snip>

>>> +static void
>>> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_pix_format *pix,
>>> +		      const struct tegra_video_format **fmtinfo)
>>> +{
>>> +	const struct tegra_video_format *info;
>>> +	unsigned int min_width;
>>> +	unsigned int max_width;
>>> +	unsigned int min_bpl;
>>> +	unsigned int max_bpl;
>>> +	unsigned int width;
>>> +	unsigned int align;
>>> +	unsigned int bpl;
>>> +
>>> +	/* Retrieve format information and select the default format if the
>>> +	 * requested format isn't supported.
>>> +	 */
>>> +	info = tegra_core_get_format_by_fourcc(pix->pixelformat);
>>> +	if (!info)
>>> +		info = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);
>> Should this not be an error? As far as I can tell this is silently
>> substituting the default format for the requested one if the requested
>> one isn't supported. Isn't the whole point of this to find out if some
>> format is supported?
>>
> I think it should return some error and escape following code. I will 
> fix that.

Actually, this code is according to the V4L2 spec: if the given format is
not supported, then VIDIOC_TRY_FMT should replace it with a valid default
format.

The reality is a bit more complex: in many drivers this was never reviewed
correctly and we ended up with some drivers that return an error for this
case and some drivers that follow the spec. Historically TV capture drivers
return an error, webcam drivers don't. Most unfortunate.

Since this driver is much more likely to be used with sensors I would
follow the spec here and substitute an invalid format with a default
format.

Regards,

	Hans
