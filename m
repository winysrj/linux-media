Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:62108 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0BBSzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 13:55:06 -0500
Message-ID: <4B6874DC.3050009@freemail.hu>
Date: Tue, 02 Feb 2010 19:54:20 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Luc Saillard <luc@saillard.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH ] libv4l: skip false Pixart markers
References: <4B67466F.1030301@freemail.hu> <4B6751F3.3040407@freemail.hu> <4B67FEAF.8050603@redhat.com>
In-Reply-To: <4B67FEAF.8050603@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 02/01/2010 11:13 PM, Németh Márton wrote:
>> From: Márton Németh<nm127@freemail.hu>
>>
>> The byte sequence 0xff, 0xff, 0xff 0xff is not a real marker to skip, instead
>> it is one byte from the image and the following three 0xff bytes might belong
>> to a real marker. Modify pixart_fill_nbits() macro to pass the first 0xff byte
>> as an image data.
>>
> 
> Oh, good catch. I'm still seeing the occasional bad frame though :(

The same at my side, this patch alone does not solve the whole problem complete.
I have the feeling that at least same of the corrupted frames will not come with
this patch, through I haven't verified this with measurement.

On the other hand, in my previous email used a little bit different code: I jumped
over the 1024 and 512 bytes without parsing it. That would be maybe necessary
to add.

By the way, is there any reason why pixart_fill_nbits() is a macro?

> While on the subject of the pac7302. I've been playing around a bit, and I have the
> feeling that if we were to go for a lower auto gain target (set autogain off and
> lower exposure, you can do this ie with v4l2ucp), combined with a gamma correction of
> 1500 (again use ie v4l2ucp), the images is much better (less over exposed, more
> contrast).
> 
> Do you agree ?

Well, my Labtec Webcam 2200 works only with acceptable indoors, when I try to
capture something outdoors under direct sunshine conditions I get overexposed
frames. I found, however, an interesting pointer in two cameras' user's manual,
see the Note column:

  http://linuxtv.org/wiki/index.php/PixArt_PAC7301/PAC7302#Identification

There is a setting indoor/outdoor which is currently not available in gspca_pac7302
driver. Maybe this would be an interesting point to figure out which register
is related to this setting.

Regards,

	Márton Németh

>> Signed-off-by: Márton Németh<nm127@freemail.hu>
>> ---
>> diff -r f23c5a878fb1 v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c
>> --- a/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Mon Feb 01 13:32:46 2010 +0100
>> +++ b/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Mon Feb 01 23:05:39 2010 +0100
>> @@ -339,10 +339,15 @@
>>   	    } \
>>   	    break; \
>>   	  case 0xff: \
>> -	    if (stream[1] == 0xff&&  (stream[2]<  7 || stream[2] == 0xff)) { \
>> -	      stream += 3; \
>> -	      c = *stream++; \
>> -	      break; \
>> +	    if (stream[1] == 0xff) { \
>> +		if (stream[2]<  7) { \
>> +		    stream += 3; \
>> +		    c = *stream++; \
>> +		    break; \
>> +		} else if (stream[2] == 0xff) { \
>> +		    /* four 0xff in a row: the first belongs to the image data */ \
>> +		    break; \
>> +		}\
>>   	    } \
>>   	    /* Error fall through */ \
>>   	  default: \
> 
> 

