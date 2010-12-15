Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0LOJzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 04:55:10 -0500
Received: by wwa36 with SMTP id 36so1387054wwa.1
        for <linux-media@vger.kernel.org>; Wed, 15 Dec 2010 01:55:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=FMQQCq1ojFnm1YzteVvC7TB90XiQvxK21F8EG@mail.gmail.com>
References: <AANLkTi=FMQQCq1ojFnm1YzteVvC7TB90XiQvxK21F8EG@mail.gmail.com>
Date: Wed, 15 Dec 2010 15:25:08 +0530
Message-ID: <AANLkTik=rJ0Q5ssdBOaRTvsENEKCRHKj8wyVMexnH=DY@mail.gmail.com>
Subject: Re: technisat cablestar hd2, cinergy C pci hd, 2.6.35, no remote (VP2040)
From: Manu Abraham <abraham.manu@gmail.com>
To: debarshi.ray@gmail.com
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, Dec 15, 2010 at 3:01 PM, Debarshi Ray <debarshi.ray@gmail.com> wrote:
> This is with reference to:
> http://www.spinics.net/lists/linux-media/msg15042.html
>
> It looks to me that the IR interface related stuff is not in the
> 2.6.35 kernel either. Since I need it for a set-top box that I
> building, I was looking for the canonical source for that code so that
> I can package it separately. Till now I have only found the bits in
> Igor's s2-liplianin tree. However it looks to me that the code did not
> originate there because the RC keymap file
> (linux/drivers/media/IR/keymaps/rc-vp2040.c) was created by a commit
> marked "merge http://linuxtv.org/hg/v4l-dvb" (hg export 15052). I am
> confused because the v4l-dvb tree does not have the VP2040 IR bits,
> and my limited knowledge of Mercurial is hindering me from figuring
> out the origins of the code.
>
> Could you kindly point me to the correct direction?


AFAIR, the code originated from these changesets:
http://jusst.de/hg/mantis-v4l-dvb.old/rev/9cb8ffc573a2
http://jusst.de/hg/mantis-v4l-dvb.old/rev/c2391fa88112

later on, it was moved to another repository
http://jusst.de/hg/mantis-v4l-dvb/rev/ad8b00c9edc2


Regards,
Manu
