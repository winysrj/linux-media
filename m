Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37657 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbZFQJcn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 05:32:43 -0400
Message-ID: <4A38B8A6.6010301@redhat.com>
Date: Wed, 17 Jun 2009 11:34:30 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
In-Reply-To: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/17/2009 09:43 AM, Hans Verkuil wrote:
>> Hi,
>>
>> I recently have been bying second hand usb webcams left and right
>> one of them (a creative unknown model) uses the cpia1 chipset, and
>> works with the v4l1 driver currently in the kernel.
>>
>> One of these days I would like to convert it to a v4l2 driver using
>> gspca as basis, this however will cause us to loose parallel port support
>> (that or we need to keep the old code around for the parallel port
>> version).
>>
>> I personally think that loosing support for the parallel port
>> version is ok given that the parallel port itself is rapidly
>> disappearing, what do you think ?
>
> I agree wholeheartedly. If we remove pp support, then we can also remove
> the bw-qcam and c-qcam drivers since they too use the parallel port.
>

Ok :)

> BTW, I also have a cpia1 camera available for testing. I can also test
> ov511 (I saw that you added support for that to gspca). Ditto for the
> stv680 and w9968cf.
>
> Note that I can mail these devices to you if you want to work on
> integrating them into gspca. I'm pretty sure I won't have time for that
> myself.
>

Yes I want to work on integrating them into gspca (as time permits).
If you could mail them to me that would be great! Esp the w9968cf one,
once that is moved to gspca, we can get rid of the entire ovcamchip stuff
(eventually it would be good to move to a model where the sensor drivers
  are seperated again, but I'm waiting to see what comes out of the
  soc / ov7660 discussion for this).

I'll send my postal address in a private mail.

Regards,

Hans
