Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:35673 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbbETSsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 14:48:47 -0400
Received: by labbd9 with SMTP id bd9so86780146lab.2
        for <linux-media@vger.kernel.org>; Wed, 20 May 2015 11:48:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150520091216.494f6d9d@recife.lan>
References: <1429859044-18071-1-git-send-email-anarsoul@gmail.com> <20150520091216.494f6d9d@recife.lan>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Wed, 20 May 2015 21:48:25 +0300
Message-ID: <CA+E=qVebcP2+1-VcQoOEJdFqcAk_3-DA=37_k6oC3ZzbRfsN7A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gspca: sn9c2028: Add support for Genius Videocam
 Live v2
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, May 20, 2015 at 3:12 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Fri, 24 Apr 2015 10:04:03 +0300
> Vasily Khoruzhick <anarsoul@gmail.com> escreveu:
>> diff --git a/drivers/media/usb/gspca/sn9c2028.c b/drivers/media/usb/gspca/sn9c2028.c
>> index 39b6b2e..317b02c 100644
>> --- a/drivers/media/usb/gspca/sn9c2028.c
>> +++ b/drivers/media/usb/gspca/sn9c2028.c
>> @@ -2,6 +2,7 @@
>>   * SN9C2028 library
>>   *
>>   * Copyright (C) 2009 Theodore Kilgore <kilgota@auburn.edu>
>> + * Copyright (C) 2015 Vasily Khoruzhick <anarsoul@gmail.com>
>
> Hmm... adding a new copyright driver-wide only justifies if you changed 30%
> or more of the code. The copyright of your changes will be preserved at
> the git history.

OK, not a problem.

Regards,
Vasily
