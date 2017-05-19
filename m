Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34386 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdESQzc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 12:55:32 -0400
Received: by mail-ua0-f174.google.com with SMTP id u10so29440937uaf.1
        for <linux-media@vger.kernel.org>; Fri, 19 May 2017 09:55:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170518184828.GA6449@dell-m4800>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
 <20170518184828.GA6449@dell-m4800>
From: Anton Sviridenko <anton@corp.bluecherry.net>
Date: Fri, 19 May 2017 20:55:31 +0400
Message-ID: <CAAMwvWt=_yYNGiFfkUERyOhSuUcgTnsXhrzUi+nU9SV4nJxAVw@mail.gmail.com>
Subject: Re: [PATCH 1/4] [media] tw5864, fc0011: better handle WARN_ON()
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Michael Buesch <m@bues.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok, I'll check this patch on tw5864 hardware bit later  and report results here

On Thu, May 18, 2017 at 10:48 PM, Andrey Utkin
<andrey_utkin@fastmail.com> wrote:
> On Thu, May 18, 2017 at 11:06:43AM -0300, Mauro Carvalho Chehab wrote:
>> As such macro will check if the expression is true, it may fall through, as
>> warned:
>
>> On both cases, it means an error, so, let's return an error
>> code, to make gcc happy.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> ---
>>  drivers/media/pci/tw5864/tw5864-video.c | 1 +
>>  drivers/media/tuners/fc0011.c           | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
>> index 2a044be729da..e7bd2b8484e3 100644
>> --- a/drivers/media/pci/tw5864/tw5864-video.c
>> +++ b/drivers/media/pci/tw5864/tw5864-video.c
>> @@ -545,6 +545,7 @@ static int tw5864_fmt_vid_cap(struct file *file, void *priv,
>>       switch (input->std) {
>>       default:
>>               WARN_ON_ONCE(1);
>> +             return -EINVAL;
>>       case STD_NTSC:
>>               f->fmt.pix.height = 480;
>>               break;
>
> Hi Mauro,
>
> Thanks for the patch.
>
> I actually meant it to fall through, but I agree this is not how it
> should be.
> I'm fine with this patch. Unfortunately I don't possess tw5864 hardware
> now. CCing Anton Sviridenko whom I've handed it (I guess he's on
> Bluecherry Maintainers groupmail as well).
>
> Anton, just in case, could you please ensure the driver with this patch
> works well in runtime?
