Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1688 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab0IGHbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 03:31:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Tue, 7 Sep 2010 09:30:55 +0200
Cc: linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele>
In-Reply-To: <20100906201105.4029d7e7@tele>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009070930.55807.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, September 06, 2010 20:11:05 Jean-Francois Moine wrote:
> Hi,
> 
> This new proposal cancels the previous 'LED control' patch.
> 
> Cheers.
> 
> 

Hi Jean-Francois,

You must also add support for these new controls in v4l2-ctrls.c in
v4l2_ctrl_get_menu(), v4l2_ctrl_get_name() and v4l2_ctrl_fill().

How is CID_ILLUMINATORS supposed to work in the case of multiple lights?
Wouldn't a bitmask type be more suitable to this than a menu type? There
isn't a bitmask type at the moment, but this seems to be a pretty good
candidate for a type like that.

Actually, for the status led I would also use a bitmask since there may be
multiple leds. I guess you would need two bitmasks: one to select auto vs
manual, and one for the manual settings.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
