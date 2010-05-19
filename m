Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:42945 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890Ab0ESXdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 19:33:00 -0400
Subject: Re: [linux-dvb] Leadtek DVT1000S W/ Phillips saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <4BF583EB.7080505@starnewsgroup.com.au>
References: <4BF583EB.7080505@starnewsgroup.com.au>
Content-Type: text/plain
Date: Thu, 20 May 2010 01:28:15 +0200
Message-Id: <1274311695.5829.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nathan,

Am Freitag, den 21.05.2010, 04:48 +1000 schrieb Nathan Metcalf:
> Hey Guys,
> I hope this is the correct place, I am trying to get a LEADTEK DVT1000S HD Tuner card working in Ubuntu (Latest)
> When I load the saa7134_dvb kernel module, there are no errors, but /dev/dvb is not created.
> 
> I have tried enabling the debug=1 option when loading the module, but don't get any more useful information.
> 
> Can someone please assist me? Or direct me to the correct place?
> 
> Regards,
> Nathan Metcalf
> 

there was some buglet previously, but the card is else supported since
Nov. 01 2009 on mercurial v4l-dvb and later kernels.

http://linuxtv.org/hg/v4l-dvb/rev/855ee0444e61b8dfe98f495026c4e75c461ce9dd

Support for the remote was also added.

Cheers,
Hermann


