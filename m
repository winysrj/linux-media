Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45751 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982AbbBQNxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 08:53:31 -0500
Message-id: <54E347D7.6090104@samsung.com>
Date: Tue, 17 Feb 2015 14:53:27 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
References: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com>
 <54E32358.8010303@cisco.com> <54E326C0.8040901@linux.intel.com>
In-reply-to: <54E326C0.8040901@linux.intel.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Sakari,

On 02/17/2015 12:32 PM, Sakari Ailus wrote:
> Hi Hans,
>
> Hans Verkuil wrote:
> ...
>>> Unfortunately, it only works one time, because the next time the user writes
>>> a zero to the control cluster_changed returns false.
>>>
>>> I think on volatile controls it is safer to run s_ctrl twice than missing a
>>> valid s_ctrl.
>>>
>>> I know I am abusing a bit the API for this :P, but I also believe that the
>>> semantic here is a bit confusing.
>>
>> The reason for that is that I have yet to see a convincing argument for
>> allowing s_ctrl for a volatile control.
>
> Well, one example are LED flash class devices which implement V4L2 flash
> API through a wrapper. The user may use the LED flash class API to
> change the values of the controls, and V4L2 framework has no clue about
> this. The V4L2 controls are volatile, and the real values of the
> settings are stored in the LED flash class.
>
> This is the current implementation (not merged yet); an alternative, a
> more correct one, would be to use callbacks to tell about the changes in
> control values. I haven't pushed for that, primarily because the
> patchset is already quite complex and I've seen this as something that
> can be always implemented later if it bothers someone.
>
> Cc Jacek.
>

Actually this will be not an issue for v4l2-flash sub-device anymore.
In the next version of the patch set the v4l2-flash sub-device
will be synchronizing the flash device registers with the
state of the controls on open.

-- 
Best Regards,
Jacek Anaszewski
