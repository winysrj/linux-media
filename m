Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:35460 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbbLLVpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 16:45:30 -0500
Subject: Re: AF9035 with no tuner?
To: Jiri Slaby <jirislaby@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
References: <566C8CC1.3040906@gmail.com> <566C8DB2.7080303@southpole.se>
 <566C90D5.1060107@gmail.com>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <566C9577.5030604@southpole.se>
Date: Sat, 12 Dec 2015 22:45:27 +0100
MIME-Version: 1.0
In-Reply-To: <566C90D5.1060107@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2015 10:25 PM, Jiri Slaby wrote:
> On 12/12/2015, 10:12 PM, Benjamin Larsson wrote:
>> On 12/12/2015 10:08 PM, Jiri Slaby wrote:
>>> Hello,
>>>
>>> I have a USB device which digitizes composite video into a MPEG-2 stream
>>> (I think). It is an AF9035 device according to windows. But it has no
>>> tuner. Is there a way to make it working on linux or am I out of luck?
>>>
>>
>> Open the device and take pictures of the pcb and the chips. After that
>> it might be possible to identify what kind of device it is.
>
> Sure:
> http://www.fi.muni.cz/~xslaby/sklad/back.JPG
> http://www.fi.muni.cz/~xslaby/sklad/front.JPG
>
> thanks,
>

Hi, seems like this device is a nogo.

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/24210

No driver support for the composite interface of the af9035. No driver 
support for the AVF 4910BA1 video digitizer chip.


MvH
Benjamin Larsson
