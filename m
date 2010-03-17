Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3493 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0CQO3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:29:15 -0400
Message-ID: <03b82834cbbe28326f10899d781d2701.squirrel@webmail.xs4all.nl>
In-Reply-To: <001001cac5dc$4407f690$cc17e3b0$%osciak@samsung.com>
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com>
    <1268831061-307-2-git-send-email-p.osciak@samsung.com>
    <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
    <001001cac5dc$4407f690$cc17e3b0$%osciak@samsung.com>
Date: Wed, 17 Mar 2010 15:29:06 +0100
Subject: RE: [PATCH v2] v4l: videobuf: code cleanup.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Pawel Osciak" <p.osciak@samsung.com>
Cc: "'Aguirre, Sergio'" <saaguirre@ti.com>,
	linux-media@vger.kernel.org,
	"Marek Szyprowski" <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> Aguirre, Sergio wrote:
>>> Make videobuf pass checkpatch; minor code cleanups.
>>
>>I thought this kind patches were frowned upon..
>>
>>http://www.mjmwired.net/kernel/Documentation/development-process/4.Coding#41
>>
>>But maybe it's acceptable in this case... I'm not an expert on community
>> policies :)
>
> Hm, right...
> I'm not an expert either, but it does seem reasonable. It was just a part
> of the
> roadmap we agreed on in Norway, so I simply went ahead with it. Merging
> with other
> patches would pollute them so I just posted it separately. I will leave
> the
> decision up to Mauro then. I have some more "normal" patches lined up,
> so please let me know. I'm guessing we are cancelling the clean-up then
> though.

As I said, you give up way too easily. There are good reasons for doing a
simple straightforward cleanup patch first before tackling all the more
complex issues. Let's get this in first, then the future patches will only
do the actual functional changes instead of them having to do codingstyle
cleanups at the same time. I want to avoid that.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

