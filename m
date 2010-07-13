Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0GMJpV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 05:45:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L5H003P5PRHA710@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Jul 2010 10:45:18 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L5H004C1PR4IW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Jul 2010 10:45:04 +0100 (BST)
Date: Tue, 13 Jul 2010 11:43:47 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [RFC v4] Multi-plane buffer support for V4L2 API
In-reply-to: <4C3B8923.1040109@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Hans de Goede' <hdegoede@redhat.com>,
	kyungmin.park@samsung.com
Message-id: <002801cb226f$e462b720$ad282560$%osciak@samsung.com>
Content-language: pl
References: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com>
 <4C3B8923.1040109@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

thanks for taking the time to look at this.

>Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>With Hans proposed changes that you've already acked, I think the proposal is
>ok,
>except for one detail:
>
>> 4. Format enumeration
>> ----------------------------------
>> struct v4l2_fmtdesc, used for format enumeration, does include the
>v4l2_buf_type
>> enum as well, so the new types can be handled properly here as well.
>> For drivers supporting both versions of the API, 1-plane formats should be
>> returned for multiplanar buffer types as well, for consistency. In other
>words,
>> for multiplanar buffer types, the formats returned are a superset of those
>> returned when enumerating with the old buffer types.
>>
>
>We shouldn't mix types here. If the userspace is asking for multi-planar
>types,
>the driver should return just the multi-planar formats.
>
>If the userspace wants to know about both, it will just call for both types
>of
>formats.

Yes. Although the idea here is that we wanted to be able to use single-planar
formats with either the old API or the new multiplane API. In the new API, you
could just set num_planes=1.

So multiplanar API != multiplanar format. When you enum_fmt for mutliplanar
types, you get "all formats you can use with the multiplanar API" and not
"all formats that have num_planes > 1".

This can simplify applications - they don't have to switch between APIs when
switching between formats. They may even choose not to use the old API at all
(if a driver allows it).

Do we want to lose the ability to use multiplanar API for single-plane
formats?

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





