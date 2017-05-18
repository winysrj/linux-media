Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.219]:23223 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755643AbdERUh7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 16:37:59 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id D33E01AAE0
        for <linux-media@vger.kernel.org>; Thu, 18 May 2017 15:08:38 -0500 (CDT)
Date: Thu, 18 May 2017 15:08:38 -0500
Message-ID: <20170518150838.Horde.QcvULS7zHP-s_vp5WQpCBSD@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [media-dvb-usb-v2] question about value overwrite
References: <20170518140901.Horde.bHPlhISMuTRMEbVjfq3p1kd@gator4166.hostgator.com>
 <00672b5e-4cf2-e271-80c1-af5c406cdb09@gmail.com>
In-Reply-To: <00672b5e-4cf2-e271-80c1-af5c406cdb09@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malcolm,

Quoting Malcolm Priestley <tvboxspy@gmail.com>:

> Hi
>
> On 18/05/17 20:09, Gustavo A. R. Silva wrote:
>>
>> Hello everybody,
>>
>> While looking into Coverity ID 1226934 I ran into the following  
>> piece of code at drivers/media/usb/dvb-usb-v2/lmedm04.c:205
>>
>> 205static int lme2510_stream_restart(struct dvb_usb_device *d)
>> 206{
>> 207        struct lme2510_state *st = d->priv;
>> 208        u8 all_pids[] = LME_ALL_PIDS;
>> 209        u8 stream_on[] = LME_ST_ON_W;
>> 210        int ret;
>> 211        u8 rbuff[1];
>> 212        if (st->pid_off)
>> 213                ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
>> 214                        rbuff, sizeof(rbuff));
>> 215        /*Restart Stream Command*/
>> 216        ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
>> 217                        rbuff, sizeof(rbuff));
>> 218        return ret;
>> 219}
>
> It is a mistake it should have been ORed ad in |= as  
> lme2510_usb_talk only returns three states.
>

I see now. The idea is to code something similar to the following  
piece of code in the same file:

242
243        ret |= lme2510_usb_talk(d, pid_buff ,
244                sizeof(pid_buff) , rbuf, sizeof(rbuf));
245
246        if (st->stream_on)
247                ret |= lme2510_stream_restart(d);
248
249        return ret;

right?

So in this case, the following patch would properly fix the bug:

index 924adfd..3ab1754 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -207,13 +207,14 @@ static int lme2510_stream_restart(struct  
dvb_usb_device *d)
         struct lme2510_state *st = d->priv;
         u8 all_pids[] = LME_ALL_PIDS;
         u8 stream_on[] = LME_ST_ON_W;
-       int ret;
+       int ret = 0;
         u8 rbuff[1];
+
         if (st->pid_off)
                 ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
                         rbuff, sizeof(rbuff));
         /*Restart Stream Command*/
-       ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+       ret |= lme2510_usb_talk(d, stream_on, sizeof(stream_on),
                         rbuff, sizeof(rbuff));
         return ret;
  }

What do you think?

> So if an error is in the running it will be returned to user.
>
> The first of your patches is better and more or less the same, the  
> second would break driver, restart is not an else condition.
>

Thank you for the clarification.
--
Gustavo A. R. Silva
