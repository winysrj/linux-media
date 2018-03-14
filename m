Return-path: <linux-media-owner@vger.kernel.org>
Received: from vl18780.dinaserver.com ([82.98.188.50]:36619 "EHLO
        vl18780.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbeCNQoE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 12:44:04 -0400
Subject: Re: [DE] Re: [CN] Re: [DE] Re: coda: i.MX6 decoding performance
 issues for multi-streaming
To: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <c18549be-d55e-54d2-1524-1c51d05807ec@by.com.es>
 <1520940054.3965.10.camel@pengutronix.de>
 <dfd0fe98-4e5e-bc28-c325-6c52f1964a03@by.com.es>
 <1521035853.4490.7.camel@pengutronix.de>
 <2df2ad29-6173-08ea-e0d1-bf54c93ee456@by.com.es>
 <1521040308.4490.10.camel@pengutronix.de>
From: Javier Martin <javiermartin@by.com.es>
Message-ID: <69970910-28ae-91a8-a7e8-04f0e6a397b1@by.com.es>
Date: Wed, 14 Mar 2018 17:43:52 +0100
MIME-Version: 1.0
In-Reply-To: <1521040308.4490.10.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello Philipp,

On 14/03/18 16:11, Philipp Zabel wrote:
> Hi Javier,
> 
> On Wed, 2018-03-14 at 15:35 +0100, Javier Martin wrote:
> [...]
>> The encoder is running on a different system with an older 4.1.0 kernel.
>> Altough the firmware version in the code is 3.1.1 as well.
>>
>> Do you think I should try updating the system in the encoder to kernel
>> 4.15 too and see if that makes any difference?
> 
> I don't think that should matter. It'd be more interesting if GOP size
> has a significant influence. Does the Problem also appear in I-frame
> only streams?
> 

OK, I've performed some tests with several resolutions and gop sizes, 
here is the table with the results:

Always playing 3 streams

| Resolution   |  QP   | GopSize   |  Kind of content |  Result       				|
| 640x368      |  25   |    16     |   Waving hands   |   time shifts, 
no DEC_PIC_SUCCESS       |
| 640x368      |  25   |    0      |   Waving hands   |   time shifts, 
no DEC_PIC_SUCCESS	|
| 320x192      |  25   |    0      |   Waving hands   |   time shifts, 
no DEC_PIC_SUCCESS 	|
| 320x192      |  25   |    16     |   Waving hands   |   time shifts, 
no DEC_PIC_SUCCESS 	|
| 1280x720     |  25   |    16     |   Waving hands   |   macroblock 
artifacts and lots of DEC_PIC_SUCCESS messages |
| 1280x720     |  25   |    0      |   Waving hands   |   Surprisingly 
smooth, no artifacts, time shifts nor DEC_PIC_SUCCESS|

* The issues always happens in the first stream, the other 2 streams are 
fine.
* With GopSize = 0 I can even decode 4 720p streams with no artifacts

It looks like for small resolutions it suffers from time shifts when 
multi-streaming, always affecting the first stream for some reason. In 
this case gop size doesn't seem to make any difference.

For higher resolutions like 720p using GopSize = 0 seems to improve 
things a lot.


Regards,
Javier.
