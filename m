Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:38706 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdK0PZq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 10:25:46 -0500
MIME-Version: 1.0
In-Reply-To: <712d80dc-d236-0e9f-e324-aa03ca16baff@xs4all.nl>
References: <20171127132027.1734806-1-arnd@arndb.de> <20171127132027.1734806-6-arnd@arndb.de>
 <712d80dc-d236-0e9f-e324-aa03ca16baff@xs4all.nl>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Nov 2017 16:25:45 +0100
Message-ID: <CAK8P3a3NOa12A4S176k3jeuRQdmJBV-DpnyaC9oD6D5BvGao-w@mail.gmail.com>
Subject: Re: [PATCH 6/8] [media] vivid: use ktime_t for timestamp calculation
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Vincent ABRIOU <vincent.abriou@st.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 27, 2017 at 4:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

>> -     ktime_get_ts(&ts);
>> -     use_alternates = ts.tv_sec % 10 >= 5;
>> +     timestamp = ktime_sub(ktime_get(), dev->radio_rds_init_time);
>> +     blk = ktime_divns(timestamp, VIVID_RDS_NSEC_PER_BLK);
>> +     use_alternates = blk % VIVID_RDS_GEN_BLOCKS;
>> +
>
> Almost right. This last line should be:
>
>         use_alternates = (blk / VIVID_RDS_GEN_BLOCKS) & 1;
>
> With that in place it works and you can add my:
>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

Makes sense. Sending a fixed version now, thanks a lot for testing!

        Arnd
