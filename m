Return-path: <linux-media-owner@vger.kernel.org>
Received: from acoma.photonsoftware.net ([65.254.60.10]:33336 "EHLO
	acoma.photonsoftware.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZHZUXT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 16:23:19 -0400
Message-ID: <4A9599B6.7050803@hubstar.net>
Date: Wed, 26 Aug 2009 21:23:18 +0100
From: "ldone@hubstar.net" <ldone@hubstar.net>
Reply-To: "l d one"@hubstar.net
MIME-Version: 1.0
To: Martin Kittel <linux@martin-kittel.de>
CC: linux-media@vger.kernel.org
Subject: Re: HVR 1300: DVB channel lock problems since 2.6.28
References: <loom.20090825T192551-363@post.gmane.org> <4A944ACA.5010800@hubstar.net> <4A958A40.8010001@martin-kittel.de>
In-Reply-To: <4A958A40.8010001@martin-kittel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Another suggestion, in mythtv, try increasing the signal something
timeout - I think the default is 1500ms.

Or scan  has an option -5 (I think -- sorry its been a while and my box
is recording) that increases the time wait before giving up.





Martin Kittel wrote:
> ldone@hubstar.net wrote:
>   
>> Have you tried Kaffeine, and scan to see what they get?
>>     
>
> Thanks for the pointer. I tried kaffeine (0.8.7) today and it looks a
> bit better with this on 2.6.31-rc7.
> While a scan with mythTV comes up with no stations found at all,
> kaffeine still finds some of the tv stations. But instead of the 27
> stations I get with both mythTV and kaffeine on 2.6.26, kaffeine finds
> only 15 stations with 2.6.31-rc7. Tuning to those then often at first
> results in a 'could not get lock error', and succeeds on the second try.
> So part of the blame might be put on mythTV but I think there is still a
> problem with the driver.
>
>   
>> You have a firmware error in the log you posted,
>>     
>
> I don't think it is a real error but just the information that the
> firmware is still missing and will be requested (and the upload was
> successful:
>
> [    6.256335] cx88[0]/2-bb: Firmware and/or mailbox pointer not
> initialized or corrupted
> [    6.260536] cx88-mpeg driver manager 0000:01:07.2: firmware:
> requesting v4l-cx2341x-enc.fw
> ...
> [    8.789850] cx88[0]/2-bb: Firmware upload successful.
> [    8.798164] cx88[0]/2-bb: Firmware version is 0x02060039
> [    8.804732] cx88[0]/2: registered device video1 [mpeg]
>
>
>   
>> You could also pull down the latest firmware files
>> http://www.linuxtv.org/downloads/firmware/
>> I think from memory you need 3 of them.
>>     
>
> To be on the safe side, I added all v4l-cx* images from that site but
> the one I actually needed (v4l-cx2341x-enc.fw) is not available there.
>
>
> So in summary, it still seems to me there is a problem with the driver
> because I cannot get all channels with kaffeine either.
>
> Best wishes,
>
> Martin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

