Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab2HTUpo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 16:45:44 -0400
Message-ID: <5032A236.7000105@redhat.com>
Date: Mon, 20 Aug 2012 22:46:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com>
In-Reply-To: <50328E22.4090805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/20/2012 09:21 PM, Mauro Carvalho Chehab wrote:
> Em 20-08-2012 10:02, Hans de Goede escreveu:

<snip>

>> Note that luckily these devices do use a unique USB id and not one of the
>> generic em28xx ids so from that pov having a specialized driver for them
>> is not an issue.
>
> Hans,
>
> Not sure if all em2765 cameras will have unique USB id's: at em28xx,
> the known em2710/em2750 cameras that don't have unique ID's; detecting
> between them requires to probe for the type of sensor.

Right, like the one I gave to Douglas and you or Douglas (don't remember) added
support for. But that one was a "regular" em28xx using camera, and this one
appears to be a bit funky in places...

I'll let Frank answer your other remarks.

Regards,

Hans
