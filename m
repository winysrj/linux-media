Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1DUNPg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 09:15:36 -0400
Message-ID: <4DB02E1A.1050207@redhat.com>
Date: Thu, 21 Apr 2011 15:16:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>
CC: linux-media@vger.kernel.org
Subject: Re: Driver for r5u870 USB webcams
References: <BANLkTim79ug6rFJDpdMAi4iaFu8=d3eXTw@mail.gmail.com>
In-Reply-To: <BANLkTim79ug6rFJDpdMAi4iaFu8=d3eXTw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 04/21/2011 03:08 PM, Jon Mason wrote:
> My laptop has the "Ricoh Co., Ltd Visual Communication Camera VGP-VCC7
> [R5U870]" webcam.  A quick scan of the kernel does not show the USB ID
> listed.  `lsusb` has it listed as:
>
> Bus 001 Device 005: ID 05ca:183a Ricoh Co., Ltd Visual Communication
> Camera VGP-VCC7 [R5U870]
>
> I managed to find a Linux driver on the internet at
> http://code.google.com/p/r5u870/
> The comment on the website seems to imply the driver has been
> abandoned by it's original writer.
>
> I am wondering if there are any plans to provide support for this
> hardware via extending another driver or if there are any plans to
> pull this driver into the kernel.

r5u87x based cams work with the regular uvcvideo driver, but first they
need to have firmware loaded into them (at every boot). See here for
the firmware load tool for linux:
https://bitbucket.org/ahixon/r5u87x/wiki/Home

Note chances are this tool is packaged for your distribution, for example
for Fedora it is available in rpmfusion nonfree under the package name
"r5u87x-firmware"

Regards,

Hans
