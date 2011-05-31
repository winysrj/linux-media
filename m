Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50007 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1EaKVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 06:21:22 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LM200DJU23KN6@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 11:21:20 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LM200M0J23IH7@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 11:21:19 +0100 (BST)
Date: Tue, 31 May 2011 12:20:07 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 0/3] TV driver for Samsung S5P platform (media part)
In-reply-to: <599405.4311306668807678.JavaMail.weblogic@epml25>
To: jiun.yu@samsung.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	=?UTF-8?B?7ISg6rK97J28?= <ki.sun@samsung.com>,
	=?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>,
	=?UTF-8?B?7J207J287Zi4?= <ilho215.lee@samsung.com>,
	=?UTF-8?B?6rmA6rK97ZmY?= <kh.k.kim@samsung.com>
Message-id: <4DE4C0D7.4070209@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <599405.4311306668807678.JavaMail.weblogic@epml25>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

JiUn Yu wrote:
>   
>> 5. Mixer & Video Processor driver. It is called 's5p-mixer' because of
>> historical reasons. It was decided combine VP and MXR drivers into one because
>> of shared interrupt and very similar interface via V4L2 nodes. The driver is a
>> realization of many-to-many relation between multiple input layers and multiple
>> outputs. All shared resources are kept in struct mxr_device. It provides
>> utilities for management and synchronization of access to resources and
>> reference counting. The outputs are obtained from HDMI/SDO private data.  One
>> layer is a single video node. Simple inheritance is applied because there only
>> little difference between layer's types. Every layer type implements set of
>> ops.  There are different ops for Mixer layers and other for VP layer.
>>     
>
> I agreed with subdev of hdmi, hdmiphy, sdo and videoDAC. It is very flexible in case of adding new interface or removing current interface.
> But 's5p-mixer' driver is not flexible. So, If new scaler is added instead of VP or mixer is someting changed,
> I think current architecture of tvout driver can't support.
> How about separating vp and mixer driver?
>   
Hi Yu,
The designed architecture TV driver was not prepared for removal of VP, 
or MIxer input nodes.
I decided only to allow flexible outputs because I knew 2 boards with 
different output configuration (Goni - only SDO, Universal - HDMI and SDO).
I need more information about VP substitute before changing design of 
the whole driver. Some of extensions could be applied by adding extra 
layer type to existing layer_vp and layer_grp ones.

Best regards
Tomasz Stanislawski
> N떑꿩�r툤y鉉싕b쾊Ф푤v�^�)頻{.n�+돴쪐{콡�bj)�鍊w*jgП�텎쉸듶줷/곴�z받뻿�2듷솳鈺�&�)傘첺뛴��췍쳺�h��j:+v돣둾�明

