Return-path: <mchehab@pedra>
Received: from racoon.tvdr.de ([188.40.50.18]:53211 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab1FJNzk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 09:55:40 -0400
Received: from whale.tvdr.de (whale.tvdr.de [192.168.100.6])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id p5ADcs8C010347
	for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 15:38:54 +0200
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by whale.tvdr.de (8.14.3/8.14.3) with ESMTP id p5ADcmEm011044
	for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 15:38:48 +0200
Message-ID: <4DF21E68.40401@tvdr.de>
Date: Fri, 10 Jun 2011 15:38:48 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH 05/13] [media] dvb/audio.h: Remove definition
 for AUDIO_GET_PTS
References: <cover.1307563765.git.mchehab@redhat.com>	<20110608172302.3e2294af@pedra>	<4DF0C015.1090807@linuxtv.org>	<4DF0C4E1.1020406@redhat.com>	<4DF0C5AB.5040304@linuxtv.org> <BANLkTi=FswJcBLH6=SMsqdmy8vk214pqiA@mail.gmail.com>
In-Reply-To: <BANLkTi=FswJcBLH6=SMsqdmy8vk214pqiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10.06.2011 15:18, Devin Heitmueller wrote:
> On Thu, Jun 9, 2011 at 9:07 AM, Andreas Oberritter<obi@linuxtv.org>  wrote:
>> ... implemented in *kernel* drivers for several generations of the dreambox.
>
> Well, let's see the source code to the drivers in question, and from
> there we can make some decisions on how to best proceed.

Just a side note: VDR uses this (and others) in its full featured
output devices. I'm not sure whether this discussion is aiming at
completely doing away with these definitions, or if there will be
a replacement. Just wanted to make you folks aware of this.

Klaus
