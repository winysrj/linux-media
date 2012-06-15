Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36406 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2FOBuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 21:50:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SfLfq-0003Tv-SX
	for linux-media@vger.kernel.org; Fri, 15 Jun 2012 03:50:07 +0200
Received: from 111-250-48-245.dynamic.hinet.net ([111.250.48.245])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 03:50:06 +0200
Received: from bruce.ying by 111-250-48-245.dynamic.hinet.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 03:50:06 +0200
To: linux-media@vger.kernel.org
From: Bruce Ying <bruce.ying@gmail.com>
Subject: Re: DVB streaming failed after running tzap
Date: Fri, 15 Jun 2012 01:45:53 +0000 (UTC)
Message-ID: <loom.20120615T033810-522@post.gmane.org>
References: <CAN6EUtu2N2hR2CLG1BWqR3mp9t0vbzfKeQXnhdB+FgeMw5Uf8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To avoid misunderstanding, I'd like to rephrase the passage below:

> SVN-r35003-4.5.2); however, if I ran tzap before launching mplayer,
> then I would get a series of "dvb_streaming_read, attempt N. 6 failed
> with errno 0 when reading 2048 bytes" failure messages. Then I must
> unplug the DiBcom USB tuner and plug it in again so that I could
> relaunch mplayer to tune to a DVB-T channel.

If I launched mplayer after running tzap, I would get a series of 
"dvb_streaming_read, attempt N. n failed with errno 0 when reading 2048 bytes" 
failure messages. I must unplug the DiBcom USB tuner and plug it in again so 
that I could relaunch mplayer to tune to a DVB-T channel.

Looks like tzap messed up something with the DiBcom kernel modules?



