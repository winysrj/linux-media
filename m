Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47837 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbFHKVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 06:21:06 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NPM005I4FF47S90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Jun 2015 11:21:04 +0100 (BST)
Message-id: <55756C8E.4020304@samsung.com>
Date: Mon, 08 Jun 2015 12:21:02 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com, gjasny@googlemail.com,
	hdegoede@redhat.com, kyungmin.park@samsung.com
Subject: Re: [v4l-utils PATCH/RFC v5 00/14] Add a plugin for Exynos4 camera
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
 <557551D9.9090607@xs4all.nl> <55755D00.1090902@samsung.com>
 <55756225.30108@xs4all.nl>
In-reply-to: <55756225.30108@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2015 11:36 AM, Hans Verkuil wrote:
> On 06/08/2015 11:14 AM, Jacek Anaszewski wrote:
>> Hi Hans,
>>
>> It got stuck on this version. I have some slight improvements locally
>> but haven't sent them as there hasn't been any comment to this so far.
>> AFAIR Sakari had some doubts about handling multiple pipelines within
>> one media controller. In this approach only one pipeline is allowed.
>> There has to be a new IOCTL added for locking pipelines, to handle this
>> IIRC.
>
> Sakari, is this ioctl really needed or something that can be added later?
>
>> Besides there are some v4l-utils build system dependency issues to
>> solve, I mentioned below in the cover letter.
>
> If I remember correctly the libmediactl API may still change, which is
> why it isn't in lib. So statically linking it isn't a bad idea at the
> moment. Laurent, can you confirm this?
>
> Is there anything else that blocks this patch series?

v4l-utils side issues:

I'd have to apply my local bug fixes and submit the next version.

Kernel side issues:

There is a regression in the kernel related to FIMC-LITE
and FIMC-IS-ISP entities. Effectively currently it is only possible
to setup pipelines with S5C73M3 sensor to fimc.0.capture and
fimc.1.capture entities.

I would also have to rebase the patches for exynos4-is driver
for avoiding failure on open when the device being opened
has no connected sensor.

-- 
Best Regards,
Jacek Anaszewski
