Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49844 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbbBKXnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 18:43:03 -0500
Message-ID: <54DBE8F5.6080803@iki.fi>
Date: Thu, 12 Feb 2015 01:42:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis de Bethencourt <luis@debethencourt.com>,
	Matthias Schwarzott <zzam@gentoo.org>
CC: Christian Engelmayer <cengelma@gmx.at>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
Subject: Re: [PATCH] [media] si2165: Fix possible leak in si2165_upload_firmware()
References: <1423688303-31894-1-git-send-email-cengelma@gmx.at> <54DBCD5D.8000409@gentoo.org> <20150211233856.GA5444@turing>
In-Reply-To: <20150211233856.GA5444@turing>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2015 01:38 AM, Luis de Bethencourt wrote:
> On Wed, Feb 11, 2015 at 10:45:01PM +0100, Matthias Schwarzott wrote:
>> On 11.02.2015 21:58, Christian Engelmayer wrote:
>>> In case of an error function si2165_upload_firmware() releases the already
>>> requested firmware in the exit path. However, there is one deviation where
>>> the function directly returns. Use the correct cleanup so that the firmware
>>> memory gets freed correctly. Detected by Coverity CID 1269120.
>>>
>>> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
>>> ---
>>> Compile tested only. Applies against linux-next.
>>> ---
>>>   drivers/media/dvb-frontends/si2165.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
>>> index 98ddb49ad52b..4cc5d10ed0d4 100644
>>> --- a/drivers/media/dvb-frontends/si2165.c
>>> +++ b/drivers/media/dvb-frontends/si2165.c
>>> @@ -505,7 +505,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
>>>   	/* reset crc */
>>>   	ret = si2165_writereg8(state, 0x0379, 0x01);
>>>   	if (ret)
>>> -		return ret;
>>> +		goto error;
>>>
>>>   	ret = si2165_upload_firmware_block(state, data, len,
>>>   					   &offset, block_count);
>>>
>> Good catch.
>>
>> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
>>
>
> Good catch indeed.
>
> Can I sign off? Not sure what the rules are.
>
> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>


You cannot sign it unless patch is going through hands. Probably you 
want review it. Check documentation "SubmittingPatches".

https://www.kernel.org/doc/Documentation/SubmittingPatches

regards
Antti

-- 
http://palosaari.fi/
