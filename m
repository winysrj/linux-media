Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab1ATNcM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 08:32:12 -0500
Message-ID: <4D383B6B.4050608@redhat.com>
Date: Thu, 20 Jan 2011 14:40:59 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas VIVIEN <progweb@free.fr>
Subject: Re: Upstreaming syntek driver
References: <AANLkTi=bv+NkwS+ASUDeAjbpNht8+YJaPRKYF7TTZDes@mail.gmail.com>	<201101182345.17725.hverkuil@xs4all.nl> <AANLkTikrXyqr8ZS7bbeJe5yPxdyxE-X-pwk=5MaLOy4N@mail.gmail.com>
In-Reply-To: <AANLkTikrXyqr8ZS7bbeJe5yPxdyxE-X-pwk=5MaLOy4N@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 01/20/2011 12:35 PM, Luca Tettamanti wrote:
> On Tue, Jan 18, 2011 at 11:45 PM, Hans Verkuil<hverkuil@xs4all.nl>  wrote:
> [...]
>> After a quick scan through the sources in svn I found the following (in no
>> particular order):
>>
>> - Supports easycap model with ID 05e1:0408: a driver for this model is now
>>   in driver/staging/easycap.
>
> Can you elaborate? Is this the same hardware?
>
>> - format conversion must be moved to libv4lconvert (if that can't already be
>>   used out of the box). Ditto for software brightness correction.
>>
>> - kill off the sysfs bits
>>
>> - kill off V4L1
>>
>> - use the new control framework for the control handling
>>
>> - use video_ioctl2 instead of the current ioctl function
>>
>> - use unlocked_ioctl instead of ioctl
>
> Ok, major surgery then :)
>
>> But probably the first step should be to see if this can't be made part of the
>> gspca driver. I can't help thinking that that would be the best approach. But
>> I guess the gspca developers can give a better idea of how hard that is.
>
> I've looked at the framework provided by gspca, it would probably
> allow to drop most of the USB support code from the driver.

Yeah, that is the whole idea :) I give a big +1 to the Hans' suggestion
to convert this to a gspca driver!

> I'm looking into frame handling.

Let me know if you need any help / explanation about how certain things
are done in gspca.

Regards,

Hans G (aka the other Hans).
