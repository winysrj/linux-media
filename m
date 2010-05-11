Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47578 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0EKERH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 00:17:07 -0400
Received: by gyg13 with SMTP id 13so2466159gyg.19
        for <linux-media@vger.kernel.org>; Mon, 10 May 2010 21:17:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE84649.3010507@tvdr.de>
References: <E1OBKmg-0006RZ-4R@www.linuxtv.org> <4BE84649.3010507@tvdr.de>
Date: Tue, 11 May 2010 01:17:05 -0300
Message-ID: <s2m68cac7521005102117x79cab3e7uda079b6a0c98d8e2@mail.gmail.com>
Subject: Re: [hg:v4l-dvb] Add FE_CAN_PSK_8 to allow apps to identify PSK_8
	capable DVB devices
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Klaus,

On Mon, May 10, 2010 at 2:45 PM, Klaus Schmidinger
<Klaus.Schmidinger@tvdr.de> wrote:
> On 10.05.2010 06:40, Patch from Klaus Schmidinger wrote:
>> The patch number 14692 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
>> to http://linuxtv.org/hg/v4l-dvb master development tree.
>>
>> Kernel patches in this development tree may be modified to be backward
>> compatible with older kernels. Compatibility modifications will be
>> removed before inclusion into the mainstream Kernel
>>
>> If anyone has any objections, please let us know by sending a message to:
>>       Linux Media Mailing List <linux-media@vger.kernel.org>
>
> This patch should not have been applied, as was decided in
> the original thread.

The patch was reverted yesterday during the hg - git sync.
http://linuxtv.org/hg/v4l-dvb/rev/9b6b81d5efbd

Thanks
Douglas
