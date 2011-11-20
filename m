Return-path: <linux-media-owner@vger.kernel.org>
Received: from nschwqsrv03p.mx.bigpond.com ([61.9.189.237]:44825 "EHLO
	nschwqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab1KTDvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 22:51:41 -0500
Received: from nschwotgx02p.mx.bigpond.com ([144.136.201.92])
          by nschwmtas04p.mx.bigpond.com with ESMTP
          id <20111120012707.GQDN14357.nschwmtas04p.mx.bigpond.com@nschwotgx02p.mx.bigpond.com>
          for <linux-media@vger.kernel.org>;
          Sun, 20 Nov 2011 01:27:07 +0000
Received: from [192.168.0.5] (really [144.136.201.92])
          by nschwotgx02p.mx.bigpond.com with ESMTP
          id <20111120012707.PJYE26052.nschwotgx02p.mx.bigpond.com@[192.168.0.5]>
          for <linux-media@vger.kernel.org>;
          Sun, 20 Nov 2011 01:27:07 +0000
Message-ID: <4EC85824.4030301@gmail.com>
Date: Sun, 20 Nov 2011 12:00:12 +1030
From: john <r.john.kent@gmail.com>
Reply-To: john@kents.id.au
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Leadtek PxDVR3200H and mythbuntu 11.04/11.10
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

I have a new Leadtek PxDVR3200H tuner card that I an trying to get 
working in mythbuntu 11.04/11.10 and with little success.

The problem seems to be that the hardware is the version that needs the 
xc4000 firmware, but the kernel drivers assume that it needs the 
xc2038-v27 firmware.

I have tried downloading clean v4l repositories and trying to patch for 
xc4000 but I can't get it to compile.
As well, I'm in Australia so I need the 7MHz version particular to our 
transmission type.

If anyone else has had success with this, I'd love to find out the 
sequence of steps that you took to do it.
Nothing I have been able to do yet works.

The card works in the machine with Windows loaded, so there is no 
problems with the card, antenna or signal strength, as I'm quite close 
to the centre of the city of Adelaide.

Hoping to hear from someone that can give me some ideas on where to go 
next.

Regards,

John Kent
