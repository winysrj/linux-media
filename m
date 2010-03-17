Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47000 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0CQOpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:45:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZF00BCQKZF8380@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:45:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZF006HJKZECV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:45:15 +0000 (GMT)
Date: Wed, 17 Mar 2010 15:43:27 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v2] v4l: videobuf: code cleanup.
In-reply-to: <A24693684029E5489D1D202277BE8944541370F8@dlee02.ent.ti.com>
To: "'Aguirre, Sergio'" <saaguirre@ti.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <001701cac5e0$3454cf80$9cfe6e80$%osciak@samsung.com>
Content-language: pl
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com>
 <1268831061-307-2-git-send-email-p.osciak@samsung.com>
 <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
 <001001cac5dc$4407f690$cc17e3b0$%osciak@samsung.com>
 <03b82834cbbe28326f10899d781d2701.squirrel@webmail.xs4all.nl>
 <A24693684029E5489D1D202277BE8944541370F8@dlee02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Aguirre, Sergio wrote:
>> >> Aguirre, Sergio wrote:
>> >>> Make videobuf pass checkpatch; minor code cleanups.
>> >>
>> >>I thought this kind patches were frowned upon..
>> >>
>> >>http://www.mjmwired.net/kernel/Documentation/development-
>> process/4.Coding#41
>> >>
>> >>But maybe it's acceptable in this case... I'm not an expert on community
>> >> policies :)
>> >
>> > Hm, right...
>> > I'm not an expert either, but it does seem reasonable. It was just a
>> part
>> > of the
>> > roadmap we agreed on in Norway, so I simply went ahead with it. Merging
>> > with other
>> > patches would pollute them so I just posted it separately. I will leave
>> > the
>> > decision up to Mauro then. I have some more "normal" patches lined up,
>> > so please let me know. I'm guessing we are cancelling the clean-up then
>> > though.
>
>It wasn't my intention to cancel your effort :) Please don't give up because of my comment.
>
>>
>> As I said, you give up way too easily. There are good reasons for doing a
>> simple straightforward cleanup patch first before tackling all the more
>> complex issues. Let's get this in first, then the future patches will only
>> do the actual functional changes instead of them having to do codingstyle
>> cleanups at the same time. I want to avoid that.
>
>Sounds reasonable.
>
>I wont say naything more about the topic. I think you guys have cleared it enough for me :)


Come on guys, I really do not give up that easily, I just went on with more important
patches. I am just a very agreeable person, that's all :)


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





