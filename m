Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:65510 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3JADXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 23:23:18 -0400
Received: by mail-oa0-f49.google.com with SMTP id i4so4360922oah.36
        for <linux-media@vger.kernel.org>; Mon, 30 Sep 2013 20:23:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52496CFE.2090700@xs4all.nl>
References: <003601ceb7fe$462af680$d280e380$%han@samsung.com>
	<52496CFE.2090700@xs4all.nl>
Date: Tue, 1 Oct 2013 08:53:18 +0530
Message-ID: <CAK9yfHziksYB6EvjjKEjkhJmoYUcvt-M6pwjisqc_REQbhgfzQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] [media] remove unnecessary pci_set_drvdata()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jingoo Han <jg1.han@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 30 September 2013 17:52, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 09/23/2013 03:43 AM, Jingoo Han wrote:
>> Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
>> (device-core: Ensure drvdata = NULL when no driver is bound),
>> the driver core clears the driver data to NULL after device_release
>> or on probe failure. Thus, it is not needed to manually clear the
>> device driver data to NULL.
>
> For the whole patch series:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

I had sent a similar series (3 days) earlier to Jingoo's  [1]. I hope
to get your ack for that one instead.

[1] http://www.spinics.net/lists/linux-media/msg68164.html


-- 
With warm regards,
Sachin
