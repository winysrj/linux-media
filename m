Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2HTVKd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 17:10:33 -0400
Message-ID: <5032A7C3.3020108@redhat.com>
Date: Mon, 20 Aug 2012 18:10:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com> <5032A236.7000105@redhat.com>
In-Reply-To: <5032A236.7000105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2012 17:46, Hans de Goede escreveu:
> Hi,
> 
> On 08/20/2012 09:21 PM, Mauro Carvalho Chehab wrote:
>> Em 20-08-2012 10:02, Hans de Goede escreveu:
> 
> <snip>
> 
>>> Note that luckily these devices do use a unique USB id and not one of the
>>> generic em28xx ids so from that pov having a specialized driver for them
>>> is not an issue.
>>
>> Hans,
>>
>> Not sure if all em2765 cameras will have unique USB id's: at em28xx,
>> the known em2710/em2750 cameras that don't have unique ID's; detecting
>> between them requires to probe for the type of sensor.
> 
> Right, like the one I gave to Douglas and you or Douglas (don't remember) added
> support for.

Yes. There are also some other similar cameras, including some special
ones (orthodontist usage, afaikt), that worked with the same driver, but
with a different sensor.

> But that one was a "regular" em28xx using camera, and this one
> appears to be a bit funky in places...
> 
> I'll let Frank answer your other remarks.

Yep. Let's see his findings before taking any decision on that.

Regards,
Mauro
