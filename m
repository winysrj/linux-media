Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52134 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1BPPEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 10:04:43 -0500
Received: from UNKNOWN (unknown [172.20.243.133])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 6CAE894012A
	for <linux-media@vger.kernel.org>; Wed, 16 Feb 2011 16:04:36 +0100 (CET)
Message-ID: <1297868675.4d5be78347984@imp.free.fr>
Date: Wed, 16 Feb 2011 16:04:35 +0100
From: franckbvl@free.fr
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] requesting firmware
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



Le 16/02/2011 09:10, Josu Lazkano a écrit :
> Hello, thanks for the reply.
>
> 2011/2/16 David Liontooth <lionteeth@cogweb.net>:
>> Does the card work? I see this sort of thing for a different card:
> Yes, it works, sometimes I have some warnings, but it works.
>
>> or51132: Waiting for firmware upload(dvb-fe-or51132-qam.fw)...
>> or51132: Version: 10001334-17430000 (133-4-174-3)
>> or51132: Firmware upload complete.
>>
>> Dave
>>
> Is this normal? Or may I configure something else?
>
> Best regards.
>
Yes, this is normal the firmware is load on the board when the first time the PC
is power on, but if you reboot the power of the board is not reset and the board
don't need to have the firmware loaded again.

Best regards,

Franck Bouvarel
