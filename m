Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:23237 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbZD3IDW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 04:03:22 -0400
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n3U86fU18014
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 10:06:41 +0200
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id n3U83JMw023804
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 10:03:19 +0200
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id D2F21436DB6
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 10:03:18 +0200 (CEST)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qKHP0PVr6Pf3 for <linux-media@vger.kernel.org>;
	Thu, 30 Apr 2009 10:03:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 2AA2144B912
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 10:03:12 +0200 (CEST)
Message-ID: <20090430100312.51659d22f1swmssg@neo.wg.de>
Date: Thu, 30 Apr 2009 10:03:12 +0200
From: Jan Schneider <jan@horde.org>
To: linux-media@vger.kernel.org
Subject: Re: PID discontinuity problems on TT C-2300
References: <20090423101312.11774iwfe0qamnms@neo.wg.de>
In-Reply-To: <20090423101312.11774iwfe0qamnms@neo.wg.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Anyone?

Zitat von Jan Schneider <jan@horde.org>:

> Hi,
>
> I tried to get help from the MythTV community to no avail. Maybe  
> it's a hardware/driver/dvb subsystem problem, I have no idea.
>
> I see two symptoms, some recordings are generated empty, i.e. Myth  
> thinks it has recorded something, but there is no video file created.
>
> Sometimes, recordings just stop in the middle. This is the only case  
> where I get a useful log entry *at all*.
> But it doesn't say anything more than:
> 2009-04-22 23:03:07.318 DVBRec(1:0): PID 0x215 discontinuity detected
> with different PIDs. This message is continuously being logged until  
> the end of the scheduled recordings, sometime interrupted by a single:
> 2009-04-22 23:03:11.220 AddTSPacket: Out of sync!!! Need to wait for  
> next payloa
> dStart PID: 0x10, continuity counter: 15 (expected 12).
>
> Please help me someone, no component of this system is logging  
> *anything* useful, this used to work one day, and I'm running out of  
> ideas and motivation into frustration.
>
> Beside several things I also tried running a recent v4l-dvb hg  
> checkout. No change.
>
> Jan.
>
> -- 
> Do you need professional PHP or Horde consulting?
> http://horde.org/consulting/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

