Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0LOLe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 06:34:58 -0500
Received: by wyb28 with SMTP id 28so1344995wyb.19
        for <linux-media@vger.kernel.org>; Wed, 15 Dec 2010 03:34:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikA15vMEcKq9jvJ59xg0OS633sHfFnJ16o0qNPZ@mail.gmail.com>
References: <AANLkTi=FMQQCq1ojFnm1YzteVvC7TB90XiQvxK21F8EG@mail.gmail.com>
	<AANLkTik=rJ0Q5ssdBOaRTvsENEKCRHKj8wyVMexnH=DY@mail.gmail.com>
	<AANLkTikA15vMEcKq9jvJ59xg0OS633sHfFnJ16o0qNPZ@mail.gmail.com>
Date: Wed, 15 Dec 2010 17:04:56 +0530
Message-ID: <AANLkTinKaoYaLtuUr2OmXbnYv8yOnwe077PaW2kEKOBE@mail.gmail.com>
Subject: Re: technisat cablestar hd2, cinergy C pci hd, 2.6.35, no remote (VP2040)
From: Manu Abraham <abraham.manu@gmail.com>
To: debarshi.ray@gmail.com
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, Dec 15, 2010 at 4:15 PM, Debarshi Ray <debarshi.ray@gmail.com> wrote:
>> AFAIR, the code originated from these changesets:
>> http://jusst.de/hg/mantis-v4l-dvb.old/rev/9cb8ffc573a2
>> http://jusst.de/hg/mantis-v4l-dvb.old/rev/c2391fa88112
>>
>> later on, it was moved to another repository
>> http://jusst.de/hg/mantis-v4l-dvb/rev/ad8b00c9edc2
>
> But the code in Igor's s2-liplianin tree has evolved further than the
> one in the mantis-v4l-dvb tree. eg., the keymaps are now split into
> separate files in drivers/media/IR/keymaps. Is there any Git tree with
> the latest state of the code or is the s2-liplianin tree the one I am
> looking for?

The latest changes are in here http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/
the IR related changes are not yet there, after the IR rework.

Regards,
Manu
