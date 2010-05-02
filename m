Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:56776 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758751Ab0EBVYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 17:24:48 -0400
Received: from [172.23.170.140] (helo=anti-virus02-07)
	by smtp-out3.blueyonder.co.uk with smtp (Exim 4.52)
	id 1O8ged-0006cL-7Y
	for linux-media@vger.kernel.org; Sun, 02 May 2010 22:24:47 +0100
Received: from [82.44.72.151] (helo=cpc1-nmal4-0-0-cust150.croy.cable.virginmedia.com)
	by asmtp-out5.blueyonder.co.uk with esmtp (Exim 4.52)
	id 1O8geZ-00061F-Lr
	for linux-media@vger.kernel.org; Sun, 02 May 2010 22:24:43 +0100
Date: Sun, 2 May 2010 22:24:44 +0100 (BST)
From: John J Lee <jjl@pobox.com>
To: linux-media@vger.kernel.org
Subject: Re: saa7146 firmware upload time?
In-Reply-To: <alpine.DEB.2.00.1005022118000.4041@alice>
Message-ID: <alpine.DEB.2.00.1005022222540.4041@alice>
References: <alpine.DEB.2.00.1005021904150.4041@alice> <201005022154.37226@orion.escape-edv.de> <alpine.DEB.2.00.1005022118000.4041@alice>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2 May 2010, John J Lee wrote:

> On Sun, 2 May 2010, Oliver Endriss wrote:
> [...]
>> Obviously, the firmware is not loaded at modprobe time. It is loaded
>> when an application opens the frontend for the first time.
> [...]
>
> Thanks.
>
> Before the frontend can be opened, open(2) must be called on a v4l device 
> file, right?  I don't appear to have such a device file (no /dev/video*, no 
> /dev/dvb/adaptor*/video*).  I had assumed the missing device file was caused 
> by the failure to load the firmware.  So it's still not clear to me how to 
> trigger the firmware loading process again (though clearly something I did 
> today triggered it once), or indeed whether that is the problem I should be 
> trying to solve.
>
> Clues welcome

OK, I still don't understand how it works, but I successfully triggered 
the firmware loading process by running kaffeine.  Thanks for your help.


John

