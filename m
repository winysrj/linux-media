Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33973 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab1IGVVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 17:21:12 -0400
Message-ID: <4E67E046.9060808@iki.fi>
Date: Thu, 08 Sep 2011 00:21:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [git:v4l-dvb/for_v3.2] [media] dvb-usb: refactor MFE code for
 individual streaming config per frontend
References: <E1R0zZM-0008EU-2T@www.linuxtv.org> <4E67DF8C.603@iki.fi>
In-Reply-To: <4E67DF8C.603@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This error is shown by VLC when channel changed:

[0x7f1bbc000cd0] dvb access error: DMXSetFilter: failed with -1 (Invalid 
argument)
[0x7f1bbc000cd0] dvb access error: DMXSetFilter failed
[0x7f1bbc32f910] main stream error: cannot pre fill buffer


but it seems to be related dvb_usb_ctrl_feed() I pointed earlier mail.

Antti


On 09/08/2011 12:18 AM, Antti Palosaari wrote:
> This patch seems to break all DVB USB devices we have. Michael, could
> you check and fix it asap.
>
> On 09/06/2011 08:21 PM, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the
>> following patch were queued at the
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] dvb-usb: refactor MFE code for individual streaming
>> config per frontend
>> Author: Michael Krufky<mkrufky@kernellabs.com>
>> Date: Tue Sep 6 09:31:57 2011 -0300
>>
>> refactor MFE code to allow for individual streaming configuration
>> for each frontend
>>
>> Signed-off-by: Michael Krufky<mkrufky@kernellabs.com>
>> Reviewed-by: Antti Palosaari<crope@iki.fi>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>> drivers/media/dvb/dvb-usb/dvb-usb-dvb.c | 141 ++++++-----
>
> dvb_usb_ctrl_feed()
> if ((adap->feedcount == onoff) && (!onoff))
> adap->active_fe = -1;
>
>
>
>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=77eed219fed5a913f59329cc846420fdeab0150f
>>
>> <diff discarded since it is too big>
>
>
> regards
> Antti
>


-- 
http://palosaari.fi/
