Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41044 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1HYMfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 08:35:20 -0400
Received: by fxh19 with SMTP id 19so1708242fxh.19
        for <linux-media@vger.kernel.org>; Thu, 25 Aug 2011 05:35:19 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: dma buffers for camera
References: <op.v0p0hctkyxxkfz@localhost.localdomain>
 <Pine.LNX.4.64.1108242111560.14818@axis700.grange>
Date: Thu, 25 Aug 2011 14:35:16 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.v0rrw2nlyxxkfz@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.1108242111560.14818@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>
> The mx2_camera driver is allocating one "discard" buffer of the same  
> size,
> as regular buffers for cases, when the user is not fast enough to queue
> new buffers for the running capture. Arguably, this could be aliminated
> and the last submitted buffer could be re-used until either more buffers
> are available or the streaming is stopped. Otherwise, it could also be
> possible to stop capture until buffers are available again. In any case,
> this is the current driver implementation. As for 2 buffers instead of  
> one
> for the actual capture, I think, gstreamer defines 2 as a minimum number
> of buffers, which is actually also required for any streaming chance.
>

Thank you for clarification...

regards
Jan



-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/
