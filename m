Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZHXIff (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 04:35:35 -0400
Message-ID: <4A925225.2080007@redhat.com>
Date: Mon, 24 Aug 2009 10:41:09 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: James Blanford <jhblanford@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Exposure set bug in stv06xx driver
References: <20090822151031.52a0f1e6@blackbart.localnet.prv> <20090823085005.77e1167a@blackbart.localnet.prv>
In-Reply-To: <20090823085005.77e1167a@blackbart.localnet.prv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/23/2009 02:50 PM, James Blanford wrote:
> Well that was quick.  These issues as well as the stream drops were
> remedied in 2.6.31-rc7,

?? I'm the author of the pb100 (046d:0840) support in
the stv06xx driver, and AFAIK there have been no changes to it
recently.

> except exposure and gain still cannot be set
> with v4l2ucp.

They can be set if you disable autogain first, just uncheck the checkbox.

> As a bonus, I found the autogain white list in
> v4l2-apps/libv4l/libv4lconvert/control/libv4lcontrol.c.  Is there a
> white list to turn on the gain and exposure manual controls?
>

This whitelist is to enable software automatic gain + exposure for camera's
which lack this in hardware (or we don't know how to do this), this is not
relevant for the 046d:0840.

> While the autogain works great, the autoloss doesn't.  Gain increases
> automatically, but is not decreased when light levels rise.

It does, but it is slow when decreasing, give it some time.

> Also,
> updating the exposure readout in v4l2ucp decreases the exposure about
> 10% and incorrectly reports an exposure somewhere between the original
> level and the changed level.  E.g., click the exposure update button
> and the exposure drops from 20000 to 18000 and reports 19000.
>

??? I've not seen any problems like these. Note that the values returned
when reading the controls are cached values of the last value set, not actually
register values. Also the range for exposure is only 0 - 511, where are
you getting values like 18000 - 20000 from ? Are you sure you are using the
in kernel gspcav2 stv06xx driver ?


Hmm, you also write:
"is there any possibility of enabling autogain?" Yet this already is enabled,
does your 046d:0840, perhaps have a different sensor, mine says when plugged
in:
STV06xx: Photobit pb0100 sensor detected

I'm not used to logitech having different camera's with the same usb-id, but you
never know.

Regards,

Hans



> Thanks for all the work.
>
>     -  Jim
>
> On Sat, 22 Aug 2009 15:10:31 -0400
> James Blanford<jhblanford@gmail.com>  wrote:
>
>> Quickcam Express 046d:0840
>>
>> Driver versions:  v 2.60 from 2.6.31-rc6 and v 2.70 from
>> gspca-c9f3938870ab
>>
>> Problem:  Overexposure and horizontal orange lines in cam image.
>> Exposure and gain controls in gqcam and v4l2ucp do not work.  By
>> varying the default exposure and gain settings in stv06xx.h, the lines
>> can be orange and/or blue, moving or stationary or a fine grid.
>>
>> Workaround:  Using the tool set_cam_exp, any exposure setting removes
>> the visual artefacts and reduces the image brightness for a given
>> set of gain and exposure settings.
>>
>> By default:
>>
>> Aug 21 14:22:02 blackbart kernel: STV06xx: Writing exposure 5000,
>> rowexp 0, srowexp 0
>>
>> Note what happens when I set the default exposure to 1000:
>>
>> Aug 21 20:44:23 blackbart kernel: STV06xx: Writing exposure 1000,
>> rowexp 0, srowexp 139438350
>>
>> By the way, is there any possibility of enabling autogain?
>>
>> Thanks for your interest,
>>
>>     -  Jim
>>
>
>
