Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:12771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab0LNNsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 08:48:12 -0500
Message-ID: <4D077581.9060008@redhat.com>
Date: Tue, 14 Dec 2010 11:47:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Artem Bokhan <aptem@ngs.ru>
CC: linux-media@vger.kernel.org
Subject: Re: problems with several saa7134 cards
References: <4D062370.8070303@ngs.ru>
In-Reply-To: <4D062370.8070303@ngs.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-12-2010 11:45, Artem Bokhan escreveu:
>  I use several (from three to five) saa7134-based cards on single PC. Currently I'm trying to migrate from 2.6.22 to 2.6.32 (ubuntu lts).
> 
> I've got problems which I did not have with 2.6.22 kernel:
> 
> 1. Depending on configuration load average holds 1 or 2 when saa7134 module is loaded. The reason is kernel process "events/".
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>    16 root      20   0     0    0    0 S    3  0.0   9:36.89 events/1
>    15 root      20   0     0    0    0 D    3  0.0   9:35.81 events/0

Probably, it is IR polling. You may disable IR via modprobe parameter:
$ modinfo saa7134|grep ir
parm:           disable_ir:disable infrared remote support (int)

Not sure if this parameter is on .32 kernel of if it were added on a newer one.

> 2. Sound and video are not synced when recording with mencoder.

I think that there are some parameters at mencoder to adjust the sync between video
and audio (-delay?). Basically, it needs to delay either audio or video, in order to sync.
The delay time is empiric, as the audio API doesn't provide any way to pass audio
timestamps, currently.
> 
> 
> The same problem with 2.6.36 kernel except "events" process have different name (can't remember exact name, sorry)
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

