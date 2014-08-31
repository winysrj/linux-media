Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50876 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaHaOsl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 10:48:41 -0400
Received: by mail-lb0-f171.google.com with SMTP id n15so4768457lbi.16
        for <linux-media@vger.kernel.org>; Sun, 31 Aug 2014 07:48:39 -0700 (PDT)
Message-ID: <54033620.4000105@googlemail.com>
Date: Sun, 31 Aug 2014 16:50:08 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Lorenzo Marcantonio <l.marcantonio@logossrl.com>,
	linux-media@vger.kernel.org
Subject: Re: strange empia device
References: <20140825190109.GB3372@aika.discordia.loc> <5403358C.4070504@googlemail.com>
In-Reply-To: <5403358C.4070504@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 31.08.2014 um 16:47 schrieb Frank Schäfer:
> Hi Lorenzo,
>
> Am 25.08.2014 um 21:01 schrieb Lorenzo Marcantonio:
>> Just bought a roxio video capture dongle. Read around that it was an
>> easycap clone (supported, then); it seems it's not so anymore :(
>>
>> It identifies as 1b80:e31d Roxio Video Capture USB
>>
>> (it also uses audio class for audio)
>>
>> Now comes the funny thing. Inside there is the usual E2P memory,
>> a regulator or two and an empia marked EM2980 (*not* em2890!); some
>> passive and nothing else.
>>
>> Digging around in the driver cab (emBDA.inf) shows that it seems an
>> em28285 driver rebranded by roxio... it installs emBDAA.sys and
>> emOEMA.sys (pretty big: about 1.5MB combined!); also a 16KB merlinFW.rom
>> (presumably a firmware for the em chip?  I tought they were fixed
>> function); also the usual directshow .ax filter and some exe in
>> autorun (emmona.exe: firmware/setup loader?).
>>
>> Looking in the em28xx gave me the idea that that thing is not
>> supported (at least in my current 3.6.6)... however the empia sites says
>> (here http://www.empiatech.com/wp/video-grabber-em282xx/) 28284 should
>> be linux supported. Nothing said about 28285. And the chip is marked
>> 2980?! by the way, forcing the driver to load I get this:
>>
>> [ 3439.787701] em28xx: New device  Roxio Video Capture USB @ 480 Mbps (1b80:e31d, interface 0, class 0)
>> [ 3439.787704] em28xx: Video interface 0 found
>> [ 3439.787705] em28xx: DVB interface 0 found
>> [ 3439.787866] em28xx #0: em28xx chip ID = 146
>>
>> Is there any hope to make it work (even on git kernel there is nothing
>> for chip id 146...)?
>>
> See http://www.spinics.net/lists/linux-media/msg73699.html
>
> HTH,
> Frank
Hmm... could you send us the output of "lsusb -v -d 1b80:e31d ?

Thanks,
Frank

