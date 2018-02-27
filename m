Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52689 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752181AbeB0Hi7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 02:38:59 -0500
Subject: Re: [PATCH v3] media: radio: Critical interrupt bugfix for si470x
 over i2c
To: Douglas Fischer <fischerdouglasc@gmail.com>,
        linux-media@vger.kernel.org
References: <20180225212713.3d78dead@Constantine>
 <cff191f8-6957-e49c-a51a-db1afb781a69@xs4all.nl>
 <20180226183947.29fa2f4d@Constantine>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <02c0e332-031e-882f-7691-7b99b4b47fd5@xs4all.nl>
Date: Tue, 27 Feb 2018 08:38:54 +0100
MIME-Version: 1.0
In-Reply-To: <20180226183947.29fa2f4d@Constantine>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2018 12:39 AM, Douglas Fischer wrote:
> Hans,
> 
> See comments below. Thank you for the quick response on this and all
> your patience and help in general with these patches.

My pleasure!

> 
> On Mon, 26 Feb 2018 12:57:26 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> On 02/26/2018 03:27 AM, Douglas Fischer wrote:
>>> Fixed si470x_start() disabling the interrupt signal, causing tune
>>> operations to never complete. This does not affect USB radios
>>> because they poll the registers instead of using the IRQ line.
>>>
>>> Stylistic and comment changes from v2.
>>>
>>> Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
>>> ---
>>>
>>> diff -uprN
>>> linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
>>> linux/drivers/media/radio/si470x/radio-si470x-common.c ---
>>> linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
>>> 2018-01-15 21:58:10.675620432 -0500 +++
>>> linux/drivers/media/radio/si470x/radio-si470x-common.c
>>> 2018-02-25 19:16:31.785934211 -0500 @@ -377,8 +377,11 @@ int
>>> si470x_start(struct si470x_device *r goto done; /* sysconfig 1 */
>>> -	radio->registers[SYSCONFIG1] =
>>> -		(de << 11) & SYSCONFIG1_DE;		/* DE*/
>>> +	radio->registers[SYSCONFIG1] |=
>>> SYSCONFIG1_RDSIEN|SYSCONFIG1_STCIEN|SYSCONFIG1_RDS;
>>> +	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;
>>> +	radio->registers[SYSCONFIG1] |= (0x01 << 2); /* GPIO2 */  
>>
>> Yes, but what does this do? Enable GPIO2? The header defines two bits
>> for GPIO1/2/3, but it doesn't say what those bits mean. So the
>> question here is what it means to set bit 2 to 1 and bit 3 to 0? The
>> header doesn't give any information about that, nor does this comment.
>>
> SYSCONFIG1_GPIO2 is bits 2 and 3, I need to clear bit 3 and set bit 2 without changing the other bits. This configures GPIO2 as "STC/RDS interrupt. A logic high will be output unless an interrupt occurs". Should I change the comment to read "/* GPIO2 STC/RDS interrupt output */"?

It might be better to have defines in the header that make this explicit.

E.g. right now we have just:

#define SYSCONFIG1_GPIO2        0x000c  /* bits 03..02: General Purpose I/O 2 */

So this could be changed to:

#define SYSCONFIG1_GPIO2_MSK     0x000c  /* bits 03..02: General Purpose I/O 2 */
#define SYSCONFIG1_GPIO2_DIS     0       /* Disable GPIO 2 interrupt */
#define SYSCONFIG1_GPIO2_STC_RDS 0x0004  /* Enable STC/RDS interrupt */
...

(I'm guessing 0 means no irq)

That way the code can become self-documenting.

Regards,

	Hans

>> Regards,
>>
>> 	Hans
>>
>>> +	if (de)
>>> +		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
>>>  	retval = si470x_set_register(radio, SYSCONFIG1);
>>>  	if (retval < 0)
>>>  		goto done;
>>>   
>>
> Thank you,
> 	Doug
> 
