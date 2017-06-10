Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:34931 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdFJDEF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 23:04:05 -0400
Received: by mail-ua0-f176.google.com with SMTP id q15so40161986uaa.2
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 20:04:05 -0700 (PDT)
Received: from mail-ua0-f176.google.com (mail-ua0-f176.google.com. [209.85.217.176])
        by smtp.gmail.com with ESMTPSA id d129sm807448vke.0.2017.06.09.20.04.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2017 20:04:04 -0700 (PDT)
Received: by mail-ua0-f176.google.com with SMTP id m31so40171230uam.1
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 20:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170608145136.601612be@vento.lan>
References: <20170607093302.59312-1-acourbot@chromium.org> <20170608145136.601612be@vento.lan>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Sat, 10 Jun 2017 12:03:43 +0900
Message-ID: <CAPBb6MV6Ko6HW_h5roK0jEs3B4Qjm9ZSkJA2iiYQPF7yAuomPw@mail.gmail.com>
Subject: Re: [PATCH] [media] media-ioc-g-topology.rst: fix typos
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 9, 2017 at 2:51 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Wed,  7 Jun 2017 18:33:02 +0900
> Alexandre Courbot <acourbot@chromium.org> escreveu:
>
>> Fix what seems to be a few typos induced by copy/paste.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>> index 48c9531f4db0..5f2d82756033 100644
>> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>> @@ -241,7 +241,7 @@ desired arrays with the media graph elements.
>>
>>  .. c:type:: media_v2_intf_devnode
>>
>> -.. flat-table:: struct media_v2_interface
>> +.. flat-table:: struct media_v2_devnode
>>      :header-rows:  0
>>      :stub-columns: 0
>>      :widths: 1 2 8
>
> Actually the fix is wrong here :-)

Whoopsie. Apologies for not double-checking. >_<

>
> I'll just fold the following diff to your patch:
>
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index 5f2d82756033..add8281494f8 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -241,7 +241,7 @@ desired arrays with the media graph elements.
>
>  .. c:type:: media_v2_intf_devnode
>
> -.. flat-table:: struct media_v2_devnode
> +.. flat-table:: struct media_v2_intf_devnode
>      :header-rows:  0
>      :stub-columns: 0
>      :widths: 1 2 8

Looks perfect now. Thanks for catching this!
