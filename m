Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34601 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbFHThZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <3768175.5Bdztn7jIp@wuerfel>
References: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
	<3768175.5Bdztn7jIp@wuerfel>
Date: Mon, 8 Jun 2015 21:37:24 +0200
Message-ID: <CAL7P5j+YfuysVeCyFQZ9DwN872Ke=PyE5fakBjdR-9h4VqN1pQ@mail.gmail.com>
Subject: Re: [Y2038] [PATCH] Staging: media: lirc: Replace timeval with ktime_t
From: =?UTF-8?Q?Ksenija_Stanojevi=C4=87?= <ksenija.stanojevic@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, Greg KH <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, mchehab@osg.samsung.com,
	jarod@wilsonet.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

It's been over two weeks that I've sent this patch.  Have you missed it?

Thanks,
Ksenija

On Fri, May 22, 2015 at 9:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 22 May 2015 17:58:42 Ksenija Stanojevic wrote:
>> 'struct timeval last_tv' is used to get the time of last signal change
>> and 'struct timeval last_intr_tv' is used to get the time of last UART
>> interrupt.
>> 32-bit systems using 'struct timeval' will break in the year 2038, so we
>> have to replace that code with more appropriate types.
>> Here struct timeval is replaced with ktime_t.
>>
>> Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
>>
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
