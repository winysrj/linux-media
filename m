Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50741 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759185AbcKCVGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 17:06:11 -0400
Subject: Re: [PATCH 17/34] [media] DaVinci-VPFE-Capture: Improve another size
 determination in vpfe_enum_input()
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <88b3de4c-5f3f-9f70-736b-039dca6b8a2e@users.sourceforge.net>
 <f214edb8-0af3-e1f5-8b45-9cfa0537f8b5@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <6a3a4a79-d428-f5d9-87e0-97fd91b75c2a@users.sourceforge.net>
Date: Thu, 3 Nov 2016 22:05:44 +0100
MIME-Version: 1.0
In-Reply-To: <f214edb8-0af3-e1f5-8b45-9cfa0537f8b5@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> @@ -1091,7 +1091,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
>>          return -EINVAL;
>>      }
>>      sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
>> -    memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
>> +    memcpy(inp, &sdinfo->inputs[index], sizeof(*inp));
> 
> If I am not mistaken this can be written as:
> 
>     *inp = sdinfo->inputs[index];
> 
> Much better.

At which position would you like to integrate a second approach for such a change
from this patch series?

* Do you expect me to send a "V2" for the whole series?

* Will an update step be appropriate if I would rebase it on other
  recently accepted suggestions?

Regards,
Markus
