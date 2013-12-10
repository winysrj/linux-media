Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:64106 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3LJEpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 23:45:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACHYQ-pjOufWCEpM=YDVwEaLtdULyEWOAhf0TFCHabLgokKxbg@mail.gmail.com>
References: <CACHYQ-pjOufWCEpM=YDVwEaLtdULyEWOAhf0TFCHabLgokKxbg@mail.gmail.com>
Date: Tue, 10 Dec 2013 10:15:15 +0530
Message-ID: <CALt3h79hx6aWADSbrYMGdccz2TZZUpy_X+S69CU-BGF4tGJ+qg@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: s5p-mfc: add controls to set vp8 enc profile
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"avnd.kiran" <avnd.kiran@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Tue, Dec 10, 2013 at 6:21 AM, Pawel Osciak <posciak@chromium.org> wrote:
> Hi Arun,
>
> On Mon, Dec 9, 2013 at 10:16 PM, Arun Kumar K <arun.kk@samsung.com> wrote:
>> Add v4l2 controls to set desired profile for VP8 encoder.
>> Acceptable levels for VP8 encoder are
>> 0: Version 0
>> 1: Version 1
>> 2: Version 2
>> 3: Version 3
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>
> Sorry, but I'm not the author of this patch, Kiran is. I think the
> confusion comes from the fact that I committed it to Chromium tree. I
> think Kiran's sign-off should go first and the patch should contain:
> "From: Kiran AVND <avnd.kiran@samsung.com>"
>

Ok will make the change in next version.

Thanks & Regards
Arun
