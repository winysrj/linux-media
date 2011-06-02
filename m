Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38367 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1FBA51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 20:57:27 -0400
Received: by vws1 with SMTP id 1so293980vws.19
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 17:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE4C0D7.4070209@samsung.com>
References: <599405.4311306668807678.JavaMail.weblogic@epml25>
	<4DE4C0D7.4070209@samsung.com>
Date: Thu, 2 Jun 2011 09:57:25 +0900
Message-ID: <BANLkTin7nEeP+o734X7rV4AkK2zTCL81dA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] TV driver for Samsung S5P platform (media part)
From: Kyungmin Park <kmpark@infradead.org>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: jiun.yu@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	=?UTF-8?B?7ISg6rK97J28?= <ki.sun@samsung.com>,
	=?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>,
	=?UTF-8?B?7J207J287Zi4?= <ilho215.lee@samsung.com>,
	=?UTF-8?B?6rmA6rK97ZmY?= <kh.k.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

It's good to know the future chip design changes. but as it doesn't be
known to others except the internal chip design team.
So with restricted information. there's no way to implement it with
current known chip.
If you want to change the design. open and show the changed IPs.

another thing is that current codes are pending for long time. so in
our case, merge it first and expand it for next chips.

Thank you,
Kyungmin Park

On Tue, May 31, 2011 at 7:20 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> JiUn Yu wrote:
>>
>>
>>>
>>> 5. Mixer & Video Processor driver. It is called 's5p-mixer' because of
>>> historical reasons. It was decided combine VP and MXR drivers into one
>>> because
>>> of shared interrupt and very similar interface via V4L2 nodes. The driver
>>> is a
>>> realization of many-to-many relation between multiple input layers and
>>> multiple
>>> outputs. All shared resources are kept in struct mxr_device. It provides
>>> utilities for management and synchronization of access to resources and
>>> reference counting. The outputs are obtained from HDMI/SDO private data.
>>>  One
>>> layer is a single video node. Simple inheritance is applied because there
>>> only
>>> little difference between layer's types. Every layer type implements set
>>> of
>>> ops.  There are different ops for Mixer layers and other for VP layer.
>>>
>>
>> I agreed with subdev of hdmi, hdmiphy, sdo and videoDAC. It is very
>> flexible in case of adding new interface or removing current interface.
>> But 's5p-mixer' driver is not flexible. So, If new scaler is added instead
>> of VP or mixer is someting changed,
>> I think current architecture of tvout driver can't support.
>> How about separating vp and mixer driver?
>>
>
> Hi Yu,
> The designed architecture TV driver was not prepared for removal of VP, or
> MIxer input nodes.
> I decided only to allow flexible outputs because I knew 2 boards with
> different output configuration (Goni - only SDO, Universal - HDMI and SDO).
> I need more information about VP substitute before changing design of the
> whole driver. Some of extensions could be applied by adding extra layer type
> to existing layer_vp and layer_grp ones.
>
> Best regards
> Tomasz Stanislawski
>>
>> N떑꿩�r툤y鉉싕b쾊Ф푤v�^�)頻{.n�+돴쪐{콡�bj)�鍊w* jgП� 텎쉸듶줷/곴�z받뻿�2듷솳鈺�&�)傘첺뛴�� 췍쳺�h�
>> �j:+v돣둾�明
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
