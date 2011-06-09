Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62632 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab1FINGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 09:06:36 -0400
Received: by wwa36 with SMTP id 36so1675864wwa.1
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2011 06:06:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110608172311.0d350ab7@pedra>
References: <20110608172311.0d350ab7@pedra>
Date: Thu, 9 Jun 2011 18:36:34 +0530
Message-ID: <BANLkTinhCz0cuu5c52DvFV+Gi0uJc3corg@mail.gmail.com>
Subject: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 6/9/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> There's a huge gap between the DVB specs and the current implementation.
> This were caused by years of changes that happened at the code but
> no updates to the specs were done.
>
> This patch series tries to reduce this gap.
>
> Basically, the headers at include/linux/dvb were included at the API.
> The Makefile scripting auto-generate references for structs, typedefs
> and ioctls. With this, it is now easy to identify when something is
> missing.
>
> After adding such logic, I've manually synchronized the specs with the
> header file and updated the data structures.
>
> The work is not complete yet: there are still several ioctl's not
> documented at the specs:

> While here, I noticed that one audio ioctl is not used anyware
> (AUDIO_GET_PTS). There is just the ioctl definition and that's it.
> I just removed this definition, as removing it won't cause any
> regression, as no in-kernel driver or dvb-core uses it.


Please do not apply this patch; the SAA716x FF DVB driver uses the same ioctl.

Best Regards,
Manu
