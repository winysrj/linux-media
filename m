Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53781 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZI1QU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 12:20:57 -0400
Received: by fxm18 with SMTP id 18so3792537fxm.17
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 09:21:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC0DC20.2070307@gmail.com>
References: <4AC0DC20.2070307@gmail.com>
Date: Mon, 28 Sep 2009 12:20:59 -0400
Message-ID: <829197380909280920v2d86d41nb42d4e90b5136215@mail.gmail.com>
Subject: Re: CX23885 card Analog/Digital Switch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "David T. L. Wong" <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 28, 2009 at 11:54 AM, David T. L. Wong
<davidtlwong@gmail.com> wrote:
> Hello List,
>
> cx23885 card Magic-Pro ProHDTV Extreme 2, has a cx23885 GPIO pin to
> select Analog TV+Radio or Digital TV. How should I add that GPIO setting
> code into cx23885?
> The current model that all operations goes to FE instead of card is not very
> appropriate to model this case.
> I thought of adding a callback code for the tuner (XC5000), but my case
>  is that this behavior is card specific, but not XC5000 generic.
>
> Is there any "Input Selection" hook / callback mechanism to notify the card,
> the device.
>
> Regards,
> David T.L. Wong

You should definitely *not* add a callback to xc5000 (and such a patch
will not be accepted).  The best approach may be to look at Michael
Krufky's fe_override tree, which is pending for merge:

http://www.kernellabs.com/hg/~mkrufky/fe_ioctl_override/

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
