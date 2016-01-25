Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46803 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbcAYI6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 03:58:07 -0500
Subject: Re: [PATCH v4 0/2] new control V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME
To: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?=
	<wuchengli@chromium.org>
References: <1453187230-97231-1-git-send-email-wuchengli@chromium.org>
 <CAOMLVLh7EnMgVfzV7JQy6DSKSaanqHn5kNkTLVrbTCihjphzYA@mail.gmail.com>
Cc: pawel@osciak.com, mchehab@osg.samsung.com, k.debski@samsung.com,
	Antti Palosaari <crope@iki.fi>,
	Masanari Iida <standby24x7@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	ao2@ao2.it, bparrot@ti.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	jtp.park@samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Daniel Kurtz <djkurtz@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A5E391.8050505@xs4all.nl>
Date: Mon, 25 Jan 2016 09:57:53 +0100
MIME-Version: 1.0
In-Reply-To: <CAOMLVLh7EnMgVfzV7JQy6DSKSaanqHn5kNkTLVrbTCihjphzYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/25/2016 05:46 AM, Wu-Cheng Li (李務誠) wrote:
> Hi Hans,
> Can you look at the patch again? I've changed the name from
> V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME to
> V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME. Thanks.

Looks good to me. I'm planning to make a pull request for this once v4.5-rc1 is
merged into our media_tree repo.

Regards,

	Hans

> 
> Wu-Cheng
> 
> On Tue, Jan 19, 2016 at 3:07 PM, Wu-Cheng Li <wuchengli@chromium.org> wrote:
>> v4 changes:
>> - Change the name to V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
>> - Add commit message to s5p-mfc patch.
>>
>> Wu-Cheng Li (2):
>>   v4l: add V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
>>   s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
>>
>>  Documentation/DocBook/media/v4l/controls.xml |  8 ++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>>  include/uapi/linux/v4l2-controls.h           |  1 +
>>  4 files changed, 23 insertions(+)
>>
>> --
>> 2.6.0.rc2.230.g3dd15c0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

