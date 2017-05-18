Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33104 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbdERTz3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 15:55:29 -0400
Subject: Re: [media-dvb-usb-v2] question about value overwrite
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170518140901.Horde.bHPlhISMuTRMEbVjfq3p1kd@gator4166.hostgator.com>
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <00672b5e-4cf2-e271-80c1-af5c406cdb09@gmail.com>
Date: Thu, 18 May 2017 20:55:25 +0100
MIME-Version: 1.0
In-Reply-To: <20170518140901.Horde.bHPlhISMuTRMEbVjfq3p1kd@gator4166.hostgator.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 18/05/17 20:09, Gustavo A. R. Silva wrote:
> 
> Hello everybody,
> 
> While looking into Coverity ID 1226934 I ran into the following piece of 
> code at drivers/media/usb/dvb-usb-v2/lmedm04.c:205
> 
> 205static int lme2510_stream_restart(struct dvb_usb_device *d)
> 206{
> 207        struct lme2510_state *st = d->priv;
> 208        u8 all_pids[] = LME_ALL_PIDS;
> 209        u8 stream_on[] = LME_ST_ON_W;
> 210        int ret;
> 211        u8 rbuff[1];
> 212        if (st->pid_off)
> 213                ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
> 214                        rbuff, sizeof(rbuff));
> 215        /*Restart Stream Command*/
> 216        ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
> 217                        rbuff, sizeof(rbuff));
> 218        return ret;
> 219}

It is a mistake it should have been ORed ad in |= as lme2510_usb_talk 
only returns three states.

So if an error is in the running it will be returned to user.

The first of your patches is better and more or less the same, the 
second would break driver, restart is not an else condition.

Regards


Malcolm
