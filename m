Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57675 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaLRJVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 04:21:31 -0500
Message-ID: <54929C3E.7020001@xs4all.nl>
Date: Thu, 18 Dec 2014 10:19:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCHv2 0/3] hdmi: add unpack and logging functions
References: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl> <54895C92.9000007@xs4all.nl> <20141218082457.GB29856@ulmo>
In-Reply-To: <20141218082457.GB29856@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/14 09:24, Thierry Reding wrote:
> On Thu, Dec 11, 2014 at 09:57:54AM +0100, Hans Verkuil wrote:
>> Hi Thierry,
>>
>> On 12/02/14 13:08, Hans Verkuil wrote:
>>> This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
>>> adds unpacking and logging functions to hdmi.c. It also uses those
>>> in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
>>> once this functionality is merged).
>>>
>>> Patches 2 and 3 have been posted before by Martin Bugge. It stalled, but
>>> I am taking over from Martin to try and get this is. I want to use this
>>> in a bunch of v4l2 drivers, so I would really like to see this merged.
>>>
>>> Changes since v1:
>>>
>>> - rename HDMI_CONTENT_TYPE_NONE to HDMI_CONTENT_TYPE_GRAPHICS to conform
>>>   to CEA-861-F.
>>> - added missing HDMI_AUDIO_CODING_TYPE_CXT.
>>> - Be explicit: out of range values are called "Invalid", reserved
>>>   values are called "Reserved".
>>> - Incorporated most of Thierry's suggestions. Exception: I didn't
>>>   create ..._get_name(buffer, length, ...) functions. I think it makes
>>>   the API awkward and I am not convinced that it is that useful.
>>>   I also kept "No Data" since that's what CEA-861-F calls it. I also
>>>   think that "No Data" is a better description than "None" since it
>>>   really means that nobody bothered to fill this in.
>>>
>>> Please let me know if there are more things that need to be addressed in
>>> these patches before they can be merged.
>>
>> Any comments about this v2?
> 
> Sorry for taking so long. This got burried under a lot of other stuff.

No problem! Much appreciated that you took the time for this review.

> I have some minor comments to patch 2/3, but on the whole this looks very
> nice.

I'll make a v3 (probably tomorrow) fixing most of your comments although I'm
keeping hdmi_log. Using dev_printk just made the code a lot harder to read
IMHO. I plan to address all other comments.

>> If not, is this something you or someone else from dri-devel will
>> take, or can it be merged through the media git repository?
> 
> I'm not aware of anyone currently doing work on this for DRM, so I think
> it'd be fine if you took it through the media git tree, especially since
> patch 3/3 clearly belongs there.

OK, great. I'd appreciate it if you can Ack the v3 patch series when it's
posted.

> If we ever need to resolve dependencies between this and new work in DRM
> we could set up a stable branch containing patches 1/3 and 2/3 which can
> be merged into both trees.

Regards,

	Hans

