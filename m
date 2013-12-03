Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47133 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3LCNbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 08:31:18 -0500
Received: by mail-ob0-f178.google.com with SMTP id uz6so14253837obc.23
        for <linux-media@vger.kernel.org>; Tue, 03 Dec 2013 05:31:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131203132355.GB30652@valkosipuli.retiisi.org.uk>
References: <1386076469-26761-1-git-send-email-m.szyprowski@samsung.com> <20131203132355.GB30652@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 3 Dec 2013 14:30:58 +0100
Message-ID: <CAPybu_22QHVarLtoBq8TSptgJ1Gkv8epANTa_67TZG=BjMQEcQ@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-dev: fix video device index assignment
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, lxr1234@hotmail.com,
	jtp.park@samsung.com, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>

On Tue, Dec 3, 2013 at 2:23 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi, Marek!
>
> Thanks for the patch.
>
> On Tue, Dec 03, 2013 at 02:14:29PM +0100, Marek Szyprowski wrote:
>> The side effect of commit 1056e4388b045 ("v4l2-dev: Fix race condition on
>> __video_register_device") is the increased number of index value assigned
>> on video_device registration. Before that commit video_devices were
>> numbered from 0, after it, the indexes starts from 1, because get_index()
>> always count the device, which is being registered. Some device drivers
>> rely on video_device index number for internal purposes, i.e. s5p-mfc
>> driver stopped working after that patch. This patch restores the old method
>> of numbering the video_device indexes.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>> In my opinion this patch should be applied also to stable v3.12 series.
>
> I agree.
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> --
> Cheers,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
