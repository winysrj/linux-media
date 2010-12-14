Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:31562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab0LNRYA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 12:24:00 -0500
Message-ID: <4D07A82B.6050205@redhat.com>
Date: Tue, 14 Dec 2010 18:23:55 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge USB Live 2
References: <4D073F83.8010301@redhat.com> <AANLkTimuS+O1rv1GL_ujj4D=gSXw+VLKh0vMc2mXx1Cd@mail.gmail.com> <4D0779A7.5090807@redhat.com> <4D079B30.3010605@redhat.com>
In-Reply-To: <4D079B30.3010605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>> $ git log --oneline --no-merges 4270c3ca.. drivers/media/video/cx231xx
>> f5db33f [media] cx231xx: stray unlock on error path
>
> Using that commit directly looks better. I still see the
> UsbInterface::sendCommand failures, but the driver seems to finish the
> initialization and looks for the firmware. So it seems something between
> -rc2 and -rc5 in mainline made it regress ...

Uhm, no.  Looks like the difference is actually the .config

The stripped-down kernel with the driver compiled in statically for a 
quick test works fine, whereas the fedora-derived configuration doesn't.

/me continues burning cpu cycles with kernel builds ;)

cheers,
   Gerd
