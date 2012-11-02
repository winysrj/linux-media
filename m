Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50252 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab2KBNlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 09:41:42 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5016919iea.19
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2012 06:41:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+6av4nv=J7wZKKbKVSGyNRVaZUO24Qv8NwbbCK8v_ZrU-7oUQ@mail.gmail.com>
References: <1351773720-22639-1-git-send-email-elezegarcia@gmail.com>
	<CA+6av4nv=J7wZKKbKVSGyNRVaZUO24Qv8NwbbCK8v_ZrU-7oUQ@mail.gmail.com>
Date: Fri, 2 Nov 2012 10:41:41 -0300
Message-ID: <CALF0-+XOLwg-Rnxm2G3mmvORXthGzeczvBEZdKGDoRZH10Wtvw@mail.gmail.com>
Subject: Re: [PATCH] stkwebcam: Fix sparse warning on undeclared symbol
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: linux-media@vger.kernel.org,
	Andrea Anacleto <andreaanacleto@libero.it>,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvydas,

On Fri, Nov 2, 2012 at 4:35 AM, Arvydas Sidorenko <asido4@gmail.com> wrote:
>> why the heck do we need this first_init?
>
> first_init was introduced in 7b1c8f58fcdbed75 for turning off LED when
> the cam finishes
> the capture.
> Andrea Anacleto <andreaanacleto@libero.it> claimed that the change
> broke his webcam
> on the same laptop, so he introduced that variable to fix the issue.
> It didn't have any
> impact to my cam so I merged it's patch and resent my fix to the maintainer.

I understand.

It sounds a bit weird to me. However, I can't argue since I don't have
a device to test.

This patch doesn't change the functionality in any way.
If you have the time to test it and stamp a "Tested-by" on it, I would
appreciate it.

Thanks,

    Ezequiel
