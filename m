Return-path: <mchehab@gaivota>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:34076 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0LOKpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 05:45:35 -0500
Received: by gwb20 with SMTP id 20so1334715gwb.1
        for <linux-media@vger.kernel.org>; Wed, 15 Dec 2010 02:45:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: debarshi.ray@gmail.com
In-Reply-To: <AANLkTik=rJ0Q5ssdBOaRTvsENEKCRHKj8wyVMexnH=DY@mail.gmail.com>
References: <AANLkTi=FMQQCq1ojFnm1YzteVvC7TB90XiQvxK21F8EG@mail.gmail.com>
	<AANLkTik=rJ0Q5ssdBOaRTvsENEKCRHKj8wyVMexnH=DY@mail.gmail.com>
Date: Wed, 15 Dec 2010 12:45:35 +0200
Message-ID: <AANLkTikA15vMEcKq9jvJ59xg0OS633sHfFnJ16o0qNPZ@mail.gmail.com>
Subject: Re: technisat cablestar hd2, cinergy C pci hd, 2.6.35, no remote (VP2040)
From: Debarshi Ray <debarshi.ray@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> AFAIR, the code originated from these changesets:
> http://jusst.de/hg/mantis-v4l-dvb.old/rev/9cb8ffc573a2
> http://jusst.de/hg/mantis-v4l-dvb.old/rev/c2391fa88112
>
> later on, it was moved to another repository
> http://jusst.de/hg/mantis-v4l-dvb/rev/ad8b00c9edc2

But the code in Igor's s2-liplianin tree has evolved further than the
one in the mantis-v4l-dvb tree. eg., the keymaps are now split into
separate files in drivers/media/IR/keymaps. Is there any Git tree with
the latest state of the code or is the s2-liplianin tree the one I am
looking for?

Thanks,
Debarshi

-- 
The camera is to the brush what Java is to assembly.
   -- Sougata Santra
