Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:51343 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0A2VzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 16:55:20 -0500
Message-ID: <4B635940.1090808@freemail.hu>
Date: Fri, 29 Jan 2010 22:55:12 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH gspca_jf tree] gspca zc3xx: signal when unknown packet
 received
References: <4B63400E.3000502@freemail.hu> <4B6355BF.7090002@redhat.com>
In-Reply-To: <4B6355BF.7090002@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> Nack!
> 
> Németh I know you mean well, but please don't go making
> semi random behavior changes to code you don't have
> hardware to test with.

I thought it is easier to write the patch I was thinking of than trying
to describe it in words. Maybe it was not the best idea, sorry about that.

> There is a good reason this code is written the way it is.
> 
> Jean-Francois,
> 
> If you wonder what this is all about, this is a patch on
> top of one of my trees which no one else has yet as
> I have not send any pull request yet, see:
> http://linuxtv.org/hg/~hgoede/gspca_jf
> 
> So back to the reason why this code is written the way it is,
> the zc3xx sends a steady stream of interrupt packets consisting
> of usually 8 0 byes, we definitely do not want to print out an
> error message every time such a packet is received.
> 
> On some cams when they are just plugged in the 6th byte (data[5])
> becomes 1 a couple of times, probably a floating pin.
> 
> And on all cams with a button, pressing that will make the
> 5th byte (data[4]) 1. As said these cam sends a steady
> stream of interrupt packets, reporting I guess the
> status of 8 gpio pins independent on whether this status
> has changed since the last packet or not.

Based on your description the following two lines could be separated:
  input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
  input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);

The first line should go when we detect a 0->1 transient (button push),
the second one when there is an 1->0 transient (button release).

In case of pac7302 there was only one event at button push. So there was
a need to simulate push and release. The camera haven't sent anything
when the button was released.


> I've tested this with the following cams:
> Logitech QuickCam IM/Connect    046d:08d9       zc3xx   HV7131R
> Logitech QuickCam E2500         046d:089d       zc3xx   MC501CB
> Labtec notebook cam             046d:08aa       zc3xx   PAS202B
> Creative WebCam Notebook        041e:401f       zc3xx   TAS5130C
> Creative Live! Cam Video IM     041e:4053       zc3xx   TAS5130-VF250
> Philips SPC 200NC               0471:0325       zc3xx   PAS106
> Creative WebCam NX Pro          041e:401e       zc3xx   HV7131B
> No brand                        0ac8:307b       zc3xx   ADCM2700
> 
> Regards,
> 
> Hans
> 
> 
> 
> On 01/29/2010 09:07 PM, Németh Márton wrote:
>> Signed-off-by: Márton Németh<nm127@freemail.hu>
>> ---
>> diff -r 95d3956ea3e5 linux/drivers/media/video/gspca/zc3xx.c
>> --- a/linux/drivers/media/video/gspca/zc3xx.c	Fri Jan 29 15:05:25 2010 +0100
>> +++ b/linux/drivers/media/video/gspca/zc3xx.c	Fri Jan 29 21:01:52 2010 +0100
>> @@ -7213,14 +7213,17 @@
>>   			u8 *data,		/* interrupt packet data */
>>   			int len)		/* interrput packet length */
>>   {
>> +	int ret = -EINVAL;
>> +
>>   	if (len == 8&&  data[4] == 1) {
>>   		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
>>   		input_sync(gspca_dev->input_dev);
>>   		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
>>   		input_sync(gspca_dev->input_dev);
>> +		ret = 0;
>>   	}
>>
>> -	return 0;
>> +	return ret;
>>   }
>>   #endif
>>
> 
> 

