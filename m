Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42553
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752504AbcKIUZa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 15:25:30 -0500
Date: Wed, 9 Nov 2016 18:25:23 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Benjamin Larsson <benjamin@southpole.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
Message-ID: <20161109182523.43af40bb@vento.lan>
In-Reply-To: <fac91957-30b0-b16f-a6f3-5bdfd0a65481@gmail.com>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
        <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
        <20161108182215.41f1f3d2@vento.lan>
        <354bc87c-79a1-bb37-6225-988c8fa429a5@southpole.se>
        <20161108193834.4b90145b@vento.lan>
        <fac91957-30b0-b16f-a6f3-5bdfd0a65481@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Nov 2016 19:57:58 +0000
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> > Yeah, I avoided serializing the logic that detects if the firmware is
> > loaded, but forgot that the power control had the same issue. The
> > newer dvb usb drivers use the dvb-usb-v2, so I didn't touch this
> > code for a while.  
> 
> I think the problem is that the usb buffer has been put in struct 
> cinergyt2_state private area which has not been initialized for initial 
> usb probing.
> 
> That was one of the main reasons for porting drivers to dvb-usb-v2.

True, but converting to dvb-usb-v2, is more complex. In particular,
dib0700 and dib3000 drivers rely on some things that may not be ported
to dvb-usb-v2.

So, I don't think we should do such change during the -rc cycle.
Also, such change requires testing. So, one with those hardware should
help with it, or the developer willing to do the conversion would
need to get those old hardware in hands.

Thanks,
Mauro
