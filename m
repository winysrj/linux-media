Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37441 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760551AbcKDIGE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 04:06:04 -0400
Subject: Re: [PATCH 17/34] [media] DaVinci-VPFE-Capture: Improve another size
 determination in vpfe_enum_input()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <88b3de4c-5f3f-9f70-736b-039dca6b8a2e@users.sourceforge.net>
 <f214edb8-0af3-e1f5-8b45-9cfa0537f8b5@xs4all.nl>
 <6a3a4a79-d428-f5d9-87e0-97fd91b75c2a@users.sourceforge.net>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3c76f5d0-4469-01a4-3a7c-49401aeb84b7@xs4all.nl>
Date: Fri, 4 Nov 2016 09:06:01 +0100
MIME-Version: 1.0
In-Reply-To: <6a3a4a79-d428-f5d9-87e0-97fd91b75c2a@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/16 22:05, SF Markus Elfring wrote:
>>> @@ -1091,7 +1091,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
>>>          return -EINVAL;
>>>      }
>>>      sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
>>> -    memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
>>> +    memcpy(inp, &sdinfo->inputs[index], sizeof(*inp));
>>
>> If I am not mistaken this can be written as:
>>
>>     *inp = sdinfo->inputs[index];
>>
>> Much better.
>
> At which position would you like to integrate a second approach for such a change
> from this patch series?
>
> * Do you expect me to send a "V2" for the whole series?

No, just for the patches I commented upon.

>
> * Will an update step be appropriate if I would rebase it on other
>   recently accepted suggestions?

You can base it on 
https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=for-v4.10a

That branch has all your other patches of this series merged and is part 
of a pull
request I posted yesterday.

	Hans

>
> Regards,
> Markus
>
