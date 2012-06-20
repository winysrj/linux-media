Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57669 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2FTHZG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 03:25:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ShFHj-0007Hw-Nl
	for linux-media@vger.kernel.org; Wed, 20 Jun 2012 09:25:03 +0200
Received: from 114-24-67-85.dynamic.hinet.net ([114.24.67.85])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 09:25:03 +0200
Received: from bruce.ying by 114-24-67-85.dynamic.hinet.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 09:25:03 +0200
To: linux-media@vger.kernel.org
From: Bruce Ying <bruce.ying@gmail.com>
Subject: Re: DVB streaming failed after running tzap
Date: Wed, 20 Jun 2012 07:22:10 +0000 (UTC)
Message-ID: <loom.20120620T092126-668@post.gmane.org>
References: <CAN6EUtu2N2hR2CLG1BWqR3mp9t0vbzfKeQXnhdB+FgeMw5Uf8g@mail.gmail.com> <loom.20120615T033810-522@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bruce Ying <bruce.ying <at> gmail.com> writes:

> If I launched mplayer after running tzap, I would get a series of 
> "dvb_streaming_read, attempt N. n failed with errno 0 when reading 2048 bytes" 
> failure messages. I must unplug the DiBcom USB tuner and plug it in again so 
> that I could relaunch mplayer to tune to a DVB-T channel.
> 
> Looks like tzap messed up something with the DiBcom kernel modules?
> 

Just found out that I should not use '-r' option for tzap before launching
"mplayer dvb://" (If 'tzap -r' were used, then 'mplayer /dev/dvb/adapterX/dvr0',
instead of 'mplayer dvb://', should be the proper syntax for the mplayer command
line.)

Or use the following pair of command lines:

$ tzap -F -c .tzap/channels.conf CTS
$ mplayer dvb://CTS



