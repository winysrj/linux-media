Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab2FBNCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jun 2012 09:02:35 -0400
Message-ID: <4FCA0EF6.3020900@redhat.com>
Date: Sat, 02 Jun 2012 15:02:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] Add HW_SEEK and TUNER_BAND capabilities
 to videodev2.h
References: <E1San4T-0004po-C8@www.linuxtv.org> <201206021415.22627.hverkuil@xs4all.nl>
In-Reply-To: <201206021415.22627.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/02/2012 02:15 PM, Hans Verkuil wrote:
> On Sat June 2 2012 11:11:53 Hans de Goede wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the
>> http://git.linuxtv.org/v4l-utils.git tree:
>>
>> Subject: Add HW_SEEK and TUNER_BAND capabilities to videodev2.h
>> Author:  Hans de Goede<hdegoede@redhat.com>
>> Date:    Sat Jun 2 11:11:53 2012 +0200
>>
>> Bring in the pending (reviewed and acked) changes from:
>
> But not merged. I think this is a bit too quick. It is good practice to wait
> with making such changes to v4l-utils until Mauro has merged the videodev2.h
> changes as well.

Ok, next time around I'll wait.

> I also have a small request:
>
> +static const char *band_names[] = {
> +       "default",
> +       "fm-eur_us",
> +       "fm-japan",
> +       "fm-russian",
> +       "fm-weather",
> +       "am-mw",
> +};
>
> Can you rename "fm-eur_us" to "fm-eur-us"? That mix of '-' and '_' is very
> jarring and awkward to type IMHO.

Done.

Regards,

Hans
