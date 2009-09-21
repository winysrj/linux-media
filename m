Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:54361 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZIUOz5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 10:55:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id 05B6AE6A89
	for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 16:46:57 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id iVGh8QBkExMg for <linux-media@vger.kernel.org>;
	Mon, 21 Sep 2009 16:46:54 +0200 (CEST)
Message-ID: <4AB791DE.1020906@linuxtv.org>
Date: Mon, 21 Sep 2009 16:46:54 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re:
References: <1252297247.18025.8.camel@morgan.walls.org>    <1252369138.2571.17.camel@morgan.walls.org>    <1253413236.13400.24.camel@morgan.walls.org>    <4AB78169.5030800@kernellabs.com> <34816.188.220.60.62.1253541249.squirrel@webmail.daily.co.uk>
In-Reply-To: <34816.188.220.60.62.1253541249.squirrel@webmail.daily.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello George,

demux0-3 represent different TS inputs. You can open each demux device
multiple times. The 128 PID filters are shared between the four devices.

Regards,
Andreas

George Joseph wrote:
> Hello All,
> 
>  I am new to the list. I am currently working on a dm7025 platform and
> would like to know if there is a possibillity to use the 128 pid filters
> on the xilleon 226. currently I see only /dev/dvb/adaptor0/demux0-3 in my
> device directory - i,e; at a point in time I can use only 4 tpid filters
> from the 128 available at hardware level.
> 
> 
> Cheers,
> Warm regs,
> G.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


