Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51726 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2GINem (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 09:34:42 -0400
Message-ID: <4FFADDEA.3000808@iki.fi>
Date: Mon, 09 Jul 2012 16:34:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi> <4FF59995.4010604@redhat.com> <4FF5A119.6020903@iki.fi> <4FF5ADE3.5040600@redhat.com> <4FF7EC0E.7060200@redhat.com> <4FF7FAB6.7040508@iki.fi> <4FF885B2.3070509@redhat.com> <4FFAA1B9.6020306@iki.fi> <4FFAAC8F.5080100@redhat.com> <4FFAC75B.5060506@iki.fi> <4FFAD666.5060402@redhat.com>
In-Reply-To: <4FFAD666.5060402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

On 07/09/2012 04:02 PM, Hans de Goede wrote:
> On 07/09/2012 01:58 PM, Antti Palosaari wrote:
>> On 07/09/2012 01:03 PM, Hans de Goede wrote:
>> If I tune using old radio it works. If I tune using latest radio but
>> with option -l 0 (./console/radio -l 0) it also works. Using "arecord
>> -D hw:2,0 -r96000 -c2 -f S16_LE | aplay -" to listen. So it seems that
>> latest radio with alsa loopback is only having those problems.
>>
>
> Ok.
>>
>> These are the patches:
>> radio-si470x: Don't unnecesarily read registers on G_TUNER
>> radio-si470x: Lower hardware freq seek signal treshold
>> radio-si470x: Always use interrupt to wait for tune/seek completion
>> radio-si470x: Lower firmware version requirements
>>
>> And from that I can see it loads new driver as it does not warn about
>> software version - only firmware.
>
> Right, so what I want to do is to lower the firmware requirement to 12,
> so that it won't complain
> for your device since that seems to be working fine. Does that sound
> like a good idea to you?

Yes, indeed lower it to the 12 as it works to get rid of those warnings. 
It still cracks but rarely, once per 2 mins or so when using arecord + 
aplay.


The whole journey of playing that device was idea to learn V4L2 radio 
API as I was planning to add SDR functionality. Anyhow, I am a little 
bit disappointed because that radio uses snd-usb-audio module for audio. 
Do you know any cheap usb radio which uses vendor specific USB 
interface, not standard profiles?


regards
Antti


-- 
http://palosaari.fi/


