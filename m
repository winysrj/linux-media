Return-path: <linux-media-owner@vger.kernel.org>
Received: from jaguar.purple-paw.com ([79.99.64.40]:45594 "EHLO
	jaguar.purple-paw.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2DGSuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 14:50:04 -0400
Message-ID: <4F808C01.1070304@rker.me.uk>
Date: Sat, 07 Apr 2012 19:48:33 +0100
From: Edd Barker <eddb@rker.me.uk>
MIME-Version: 1.0
To: Michael Hagner <mikahagner@arcor.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: DVB-T USB Stick Pinnacle PCTV
References: <201204070522.06252.mikahagner@arcor.de> <C8B6DA92-5EAC-414F-BCDA-AA48AA750924@rker.me.uk>
In-Reply-To: <C8B6DA92-5EAC-414F-BCDA-AA48AA750924@rker.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael.

If I remember right this stick needs the media_build git. Try:

git clone git://linuxtv.org/media_build.git
cd media_build
./build

I can check more when I'm at my pc if that doesn't work.

Edd


> On 7 Apr 2012, at 04:22, Michael Hagner <mikahagner@arcor.de
> <mailto:mikahagner@arcor.de>> wrote:
>
>> Hello,
>>
>> I' ve tried to install the above mentioned USB-device,
>> but the system doesn't work e.g. the device hasn't
>> been recognized from the system.
>>
>> Kubuntu 10.10 Kernel ...35.28
>>
>> Do you have some information to solve that problem ?
>> I believe, that's the USB port....maybe I've to use the insmod....see the
>> bold red mark in the syslog.
>>
>> Thanks in advance...
>>
>> Michael
>>
>> Att.: Syslog
>> <USB_TV.odt>
