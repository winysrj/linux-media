Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.147]:44946 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755215AbdERTJG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 15:09:06 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id AB396400DEF1B
        for <linux-media@vger.kernel.org>; Thu, 18 May 2017 14:09:02 -0500 (CDT)
Date: Thu, 18 May 2017 14:09:01 -0500
Message-ID: <20170518140901.Horde.bHPlhISMuTRMEbVjfq3p1kd@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [media-dvb-usb-v2] question about value overwrite
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello everybody,

While looking into Coverity ID 1226934 I ran into the following piece  
of code at drivers/media/usb/dvb-usb-v2/lmedm04.c:205

205static int lme2510_stream_restart(struct dvb_usb_device *d)
206{
207        struct lme2510_state *st = d->priv;
208        u8 all_pids[] = LME_ALL_PIDS;
209        u8 stream_on[] = LME_ST_ON_W;
210        int ret;
211        u8 rbuff[1];
212        if (st->pid_off)
213                ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
214                        rbuff, sizeof(rbuff));
215        /*Restart Stream Command*/
216        ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
217                        rbuff, sizeof(rbuff));
218        return ret;
219}

The issue is that the value store in variable _ret_ at line 213 is  
overwritten by the one stored at line 216, before it can be used.

My question is if an _else_ statement is missing, or the variable  
assignment at line 213 should be removed, leaving just the call  
lme2510_usb_talk(d, all_pids, sizeof(all_pids), rbuff, sizeof(rbuff));  
in place.

Maybe either of the following patches could be applied:

index 924adfd..d573144 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -207,15 +207,15 @@ static int lme2510_stream_restart(struct  
dvb_usb_device *d)
         struct lme2510_state *st = d->priv;
         u8 all_pids[] = LME_ALL_PIDS;
         u8 stream_on[] = LME_ST_ON_W;
-       int ret;
         u8 rbuff[1];
+
         if (st->pid_off)
-               ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
+               lme2510_usb_talk(d, all_pids, sizeof(all_pids),
                         rbuff, sizeof(rbuff));
+
         /*Restart Stream Command*/
-       ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+       return lme2510_usb_talk(d, stream_on, sizeof(stream_on),
                         rbuff, sizeof(rbuff));
-       return ret;
  }

index 924adfd..dd51f05 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -207,15 +207,15 @@ static int lme2510_stream_restart(struct  
dvb_usb_device *d)
         struct lme2510_state *st = d->priv;
         u8 all_pids[] = LME_ALL_PIDS;
         u8 stream_on[] = LME_ST_ON_W;
-       int ret;
         u8 rbuff[1];
+
         if (st->pid_off)
-               ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
+               return lme2510_usb_talk(d, all_pids, sizeof(all_pids),
                         rbuff, sizeof(rbuff));
-       /*Restart Stream Command*/
-       ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+       else
+               /*Restart Stream Command*/
+               return lme2510_usb_talk(d, stream_on, sizeof(stream_on),
                         rbuff, sizeof(rbuff));
-       return ret;
  }

What do you think?

I'd really appreciate any comment on this.

Thank you!
--
Gustavo A. R. Silva
