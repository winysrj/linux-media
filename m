Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36334 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbdAFVVM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 16:21:12 -0500
Received: by mail-io0-f169.google.com with SMTP id p127so65881016iop.3
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2017 13:21:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161219195637.GA15652@dell-m4800>
References: <20161217010536.GA140725@beast> <20161219195637.GA15652@dell-m4800>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 6 Jan 2017 13:21:10 -0800
Message-ID: <CAGXu5jKFA6MtEWOFm+HDb1yy1pp9uFoRDS02G4qqn-7wWK7P7A@mail.gmail.com>
Subject: Re: [PATCH] solo6x10: use designated initializers
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, andrey_utkin@fastmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 19, 2016 at 11:56 AM, Andrey Utkin
<andrey.utkin@corp.bluecherry.net> wrote:
> On Fri, Dec 16, 2016 at 05:05:36PM -0800, Kees Cook wrote:
>> Prepare to mark sensitive kernel structures for randomization by making
>> sure they're using designated initializers. These were identified during
>> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
>> extracted from grsecurity.
>
> Ok I've reviewed all the patchset, googled a bit and now I see what's
> going on.
>
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
>> index 6a35107aca25..36e93540bb49 100644
>> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
>> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
>> @@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
>>
>>  int solo_g723_init(struct solo_dev *solo_dev)
>>  {
>> -     static struct snd_device_ops ops = { NULL };
>> +     static struct snd_device_ops ops = { };
>
> I'm not that keen on syntax subtleties, but...
>  * Empty initializer is not quite "designated" as I can judge.
>  * From brief googling I see that empty initializer is not valid in
>    some C standards.
>
> Since `ops` is static, what about this?
> For the variant given below, you have my signoff.
>
>> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
>> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
>> @@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
>>
>>  int solo_g723_init(struct solo_dev *solo_dev)
>>  {
>> -     static struct snd_device_ops ops = { NULL };
>> +     static struct snd_device_ops ops;

Ah! Yes, thanks. That works fine too. :) Can this be const as well?

-Kees

-- 
Kees Cook
Nexus Security
