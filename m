Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab3FQGe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 02:34:59 -0400
Message-ID: <51BEAE0A.7060706@redhat.com>
Date: Mon, 17 Jun 2013 08:34:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Guy Martin <gmsoft@tuxicoman.be>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Doing a v4l-utils-1.0.0 release
References: <51BAC2F6.40708@redhat.com> <20130614103404.3dc2c4bf@redhat.com> <20130615123337.1ba83c63@borg.bxl.tuxicoman.be>
In-Reply-To: <20130615123337.1ba83c63@borg.bxl.tuxicoman.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/15/2013 12:33 PM, Guy Martin wrote:
>
> On Fri, 14 Jun 2013 10:34:04 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>> Em Fri, 14 Jun 2013 09:15:02 +0200
>> Hans de Goede <hdegoede@redhat.com> escreveu:
>>
>>> Hi All,
>>>
>>> IIRC the 0.9.x series were meant as development releases leading up
>>> to a new stable 1.0.0 release. Lately there have been no
>>> maintenance 0.8.x releases and a lot of interesting development
>>> going on in the 0.9.x, while at the same time there have been no
>>> issues reported against 0.9.x (iow it seems stable).
>>>
>>> So how about taking current master and releasing that as a 1.0.0
>>> release ?
>>
>> Fine for me.
>>
>> There are 5 patches floating at patchwork to improve the DVB-S
>> support with different types of DiSEqC, but applying them would break
>> library support for tvd. So, they won't be applied as-is, and Guy
>> needs to take some other approach. As he is also planning to add
>> support there for rotors, it looks ok to postpone such changes to a
>> latter version.
>
> Can we wait a little bit more like a week max ?

Sure, I was just trying to see what people think about doing a 1.0.0
release. I see no reason to rush it.

Regards,

Hans
