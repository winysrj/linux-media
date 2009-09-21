Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37248 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZIUUtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 16:49:24 -0400
Received: by fxm18 with SMTP id 18so348678fxm.17
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 13:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090921204418.GA19119@zverina>
References: <20090913193118.GA12659@zverina> <20090921204418.GA19119@zverina>
Date: Mon, 21 Sep 2009 16:49:26 -0400
Message-ID: <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 4:44 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> Hello.
>
> Partial success. With the attached patch, DVB works. But I have no idea
> how to get analog audio working correctly. Any help would be
> appreciated.
>
> Regards,
> Uroš

Hello Uroš,

Sorry I somehow missed your previous email.  I have a patch already
which should make the device work correctly, and am issuing a PULL
request for it this week.

Regarding the analog audio, I'm not sure how you are testing, but if
you are using tvtime, it is known that tvtime does not support analog
audio for raw devices such as this.  You need to run arecord/aplay in
a separate window.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
