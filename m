Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35510 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1IGVfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 17:35:42 -0400
Received: by gya6 with SMTP id 6so90911gya.19
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2011 14:35:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E67E046.9060808@iki.fi>
References: <E1R0zZM-0008EU-2T@www.linuxtv.org>
	<4E67DF8C.603@iki.fi>
	<4E67E046.9060808@iki.fi>
Date: Wed, 7 Sep 2011 17:35:41 -0400
Message-ID: <CAOcJUbzuKB5aXbfo9Ao5abuR_LvG3L17EhhOX-sKUVoVkURHmg@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.2] [media] dvb-usb: refactor MFE code for
 individual streaming config per frontend
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On 09/08/2011 12:18 AM, Antti Palosaari wrote:
>>
>> This patch seems to break all DVB USB devices we have. Michael, could
>> you check and fix it asap.
>>
>> On 09/06/2011 08:21 PM, Mauro Carvalho Chehab wrote:
>>>
>>> This is an automatic generated email to let you know that the
>>> following patch were queued at the
>>> http://git.linuxtv.org/media_tree.git tree:
>>>
>>> Subject: [media] dvb-usb: refactor MFE code for individual streaming
>>> config per frontend
>>> Author: Michael Krufky<mkrufky@kernellabs.com>
>>> Date: Tue Sep 6 09:31:57 2011 -0300
>>>
>>> refactor MFE code to allow for individual streaming configuration
>>> for each frontend
>>>
>>> Signed-off-by: Michael Krufky<mkrufky@kernellabs.com>
>>> Reviewed-by: Antti Palosaari<crope@iki.fi>
>>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>
>>> drivers/media/dvb/dvb-usb/dvb-usb-dvb.c | 141 ++++++-----
>>
>> dvb_usb_ctrl_feed()
>> if ((adap->feedcount == onoff) && (!onoff))
>> adap->active_fe = -1;
>>
>>
>>
>>>
>>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=77eed219fed5a913f59329cc846420fdeab0150f
>>>
>>> <diff discarded since it is too big>
>>
>>

On Wed, Sep 7, 2011 at 5:21 PM, Antti Palosaari <crope@iki.fi> wrote:
> This error is shown by VLC when channel changed:
>
> [0x7f1bbc000cd0] dvb access error: DMXSetFilter: failed with -1 (Invalid
> argument)
> [0x7f1bbc000cd0] dvb access error: DMXSetFilter failed
> [0x7f1bbc32f910] main stream error: cannot pre fill buffer
>
>
> but it seems to be related dvb_usb_ctrl_feed() I pointed earlier mail.
>
> Antti
>
>


I will take a look at this tonight and give it a test with vlc.
Thanks for reporting the problem.

Regards,

Mike
