Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56153 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031514Ab2CORKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 13:10:02 -0400
Received: by gghe5 with SMTP id e5so3271081ggh.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 10:10:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+WfFTGZZv5R-x+hDrG_T9FXPk8JM-aNAnRKdNa=QA4cXA@mail.gmail.com>
References: <CALF0-+WfFTGZZv5R-x+hDrG_T9FXPk8JM-aNAnRKdNa=QA4cXA@mail.gmail.com>
Date: Thu, 15 Mar 2012 14:10:02 -0300
Message-ID: <CA+MoWDr+NShCpvn9KvT6nP5hG0569ewuWtmM+5DEeVeTZEGjkg@mail.gmail.com>
Subject: Re: [Q] tracing/printing
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	devel <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel,

Not sure, but this may help you:

http://lwn.net/Articles/464276/

[]'s

Peter

2012/3/14 Ezequiel García <elezegarcia@gmail.com>:
> Hi,
>
> I'm writing a video capture device and have a doubt about how to
> correctly print to screen.
>
> First, I suppose I should follow the rule "don't print unless there is
> something surprising to say", right?
> Second, I've found I need to print in a very verbose manner
> at developing stage so I should implement a debug param.
> I will probably adopt videobuf2 way (like many others) of
> defining a macro (dprintk or something).
>
> However, reading the source I've found there isn't a unified
> way to do this: some use printk (as defined macros), others
> use v4l_xxx, others use dev_xxx.
>
> I've adopted the latter, because I thought there could
> be many devices plugged, and using dev_xxx with
> the usb_device->dev helps seeing which is tracing.
>
> I'm not really sure if it is ok so I would love to
> hear some opinions about this sensible issue.
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
