Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44814 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbbEHLSq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 07:18:46 -0400
Message-ID: <554C9B78.2060808@xs4all.nl>
Date: Fri, 08 May 2015 13:18:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: Re: [PATCH v6 05/11] rc: Add HDMI CEC protoctol handling
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-6-git-send-email-k.debski@samsung.com> <554C97C3.5030806@xs4all.nl>
In-Reply-To: <554C97C3.5030806@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2015 01:02 PM, Hans Verkuil wrote:
> On 05/04/2015 07:32 PM, Kamil Debski wrote:
>> Add handling of remote control events coming from the HDMI CEC bus.
>> This patch includes a new keymap that maps values found in the CEC
>> messages to the keys pressed and released. Also, a new protocol has
>> been added to the core.
>>
>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

But if you could fix the typo in the subject: protoctol -> protocol, then
that would be appreciated...

Regards,

	Hans

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

