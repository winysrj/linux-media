Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:6246 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeJ3Mya (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 08:54:30 -0400
Subject: Re: [PATCH] media: dvb: fix a missing-check bug
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, prabhakar.csengg@gmail.com
References: <1539958334-11531-1-git-send-email-wang6495@umn.edu>
 <CAAa=b7ceXdaB9KcZy9ML5pcEwMjYF0ibaB_f6LuuHFe_jSuMYQ@mail.gmail.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <4cb84899-8856-654b-e38a-a800b56cf76c@linux.intel.com>
Date: Tue, 30 Oct 2018 12:07:12 +0800
MIME-Version: 1.0
In-Reply-To: <CAAa=b7ceXdaB9KcZy9ML5pcEwMjYF0ibaB_f6LuuHFe_jSuMYQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think need Cc to Lad, Prabhakar <prabhakar.csengg@gmail.com>

On 10/30/2018 02:46 AM, Wenwen Wang wrote:
> Hello,
>
> Can anyone confirm this bug? Thanks!
>
> Wenwen
>
> On Fri, Oct 19, 2018 at 9:12 AM Wenwen Wang <wang6495@umn.edu> wrote:
>> In dvb_audio_write(), the first byte of the user-space buffer 'buf' is
>> firstly copied and checked to see whether this is a TS packet, which always
>> starts with 0x47 for synchronization purposes. If yes, ts_play() will be
>> called. Otherwise, dvb_aplay() will be called. In ts_play(), the content of
>> 'buf', including the first byte, is copied again from the user space.
>> However, after the copy, no check is re-enforced on the first byte of the
>> copied data.  Given that 'buf' is in the user space, a malicious user can
>> race to change the first byte after the check in dvb_audio_write() but
>> before the copy in ts_play(). Through this way, the user can supply
>> inconsistent code, which can cause undefined behavior of the kernel and
>> introduce potential security risk.
>>
>> This patch adds a necessary check in ts_play() to make sure the first byte
>> acquired in the second copy contains the expected value. Otherwise, an
>> error code EINVAL will be returned.
>>
>> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
>> ---
>>  drivers/media/pci/ttpci/av7110_av.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
>> index ef1bc17..1ff6062 100644
>> --- a/drivers/media/pci/ttpci/av7110_av.c
>> +++ b/drivers/media/pci/ttpci/av7110_av.c
>> @@ -468,6 +468,8 @@ static ssize_t ts_play(struct av7110 *av7110, const char __user *buf,
>>                 }
>>                 if (copy_from_user(kb, buf, TS_SIZE))
>>                         return -EFAULT;
>> +               if (kb[0] != 0x47)
>> +                       return -EINVAL;
>>                 write_ts_to_decoder(av7110, type, kb, TS_SIZE);
>>                 todo -= TS_SIZE;
>>                 buf += TS_SIZE;
>> --
>> 2.7.4
>>
