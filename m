Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36753 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab1DZVL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 17:11:56 -0400
Received: by qyk7 with SMTP id 7so1438645qyk.19
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2011 14:11:56 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 15:11:54 -0600
Message-ID: <BANLkTi=H7wtqbmih2=g0YiEuLkeb=c88Cw@mail.gmail.com>
Subject: analog OTA tuning
From: Martin Cole <mjcoogle@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sorry if this is a repeat, I was getting repeated bounce messages due
to html formatting...

I am interested in adding this support if it does not yet exist, or
talking to someone about adding this support.

thanks,
--mc


Here is my original mail:

Hi,

I need to tune analog OTA channels from a pci-e card.  I bought the
following card:

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200  (I
actually have the 2250)

after installing and downloading the firmware etc, this works fine
when tuning the digital OTA signal that I can see locally.

I am unsure how to change the frontend to attempt to tune analog tv
input or even if this is supported, can someone point me in the right
direction to do this? It looks like I would need to change the tuner
type in the driver code (if analog is supported)

I am aware that no analog broadcasts exist anymore in the US, but
where this will eventually be used still has analog OTA broadcasts.
My test setup for now includes a digital to analog converter, which i
would like to tune with this card, once this works I would test with
the actual OTA signal.

Looking at the tuner chip on the card, suggests that it is possible.
The link on the wiki for the chip is outdated it seems, this is what I
found on the nxp site:

http://www.nxp.com/#/pip/pip=[pip=TDA18271HD]|pp=[t=pip,i=TDA18271HD]

I am happy to dive into the code, but wanted to see if anyone has done
this already or get any suggestions that you more experienced
developers could provide.

Thanks,
--mc
