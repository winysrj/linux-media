Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3941 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFSMri (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 08:47:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Halim Sahin <halim.sahin@t-online.de>
Subject: Re: ok more details: Re: bttv problem loading takes about several minutes
Date: Fri, 19 Jun 2009 14:47:33 +0200
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
References: <28237.62.70.2.252.1245331454.squirrel@webmail.xs4all.nl> <1245352904.3924.3.camel@pc07.localdom.local> <20090619114937.GA4493@halim.local>
In-Reply-To: <20090619114937.GA4493@halim.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191447.33642.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 June 2009 13:49:37 Halim Sahin wrote:
> Hi,
> Ok I have tested
> modprobe bttv audiodev=-1 card=34 tuner=24 gbuffers=16
>
> I am seeing again the delay.
> More ideas?

Use more printk messages in the bttv_init_card2() function to try and narrow 
down the exact function call that is causing the delay. I still have no 
idea what it might be.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
