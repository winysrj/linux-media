Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0JAFqe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 01:46:34 -0400
Message-ID: <4CA575AC.5090901@redhat.com>
Date: Fri, 01 Oct 2010 02:46:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>, Srinivasa.Deevi@conexant.com,
	Palash.Bandyopadhyay@conexant.com, dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 08/10] V4L/DVB: tda18271: allow restricting max out to
 4 bytes
References: <cover.1285699057.git.mchehab@redhat.com>	<20100928154659.0e7e4147@pedra>	<AANLkTik_3MSjyqokvam28g5ohhCP=bb=_uzyzK0iM8Et@mail.gmail.com>	<4CA5088B.1060604@iki.fi> <AANLkTinGk2bHCrrC2b=ZiTynh9Vh4LjLCju4ke-mCSzz@mail.gmail.com>
In-Reply-To: <AANLkTinGk2bHCrrC2b=ZiTynh9Vh4LjLCju4ke-mCSzz@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-09-2010 19:07, Michael Krufky escreveu:
> On Thu, Sep 30, 2010 at 6:00 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 09/30/2010 09:52 PM, Michael Krufky wrote:
>>>
>>> On Tue, Sep 28, 2010 at 2:46 PM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com>  wrote:
>>>>
>>>> By default, tda18271 tries to optimize I2C bus by updating all registers
>>>> at the same time. Unfortunately, some devices doesn't support it.
>>>>
>>>> The current logic has a problem when small_i2c is equal to 8, since there
>>>> are some transfers using 11 + 1 bytes.
>>>>
>>>> Fix the problem by enforcing the max size at the right place, and allows
>>>> reducing it to max = 3 + 1.
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>>
>>> This looks to me as if it is working around a problem on the i2c
>>> master.  I believe that a fix like this really belongs in the i2c
>>> master driver, it should be able to break the i2c transactions down
>>> into transactions that the i2c master can handle.
>>>
>>> I wouldn't want to merge this without a better explanation of why it
>>> is necessary in the tda18271 driver.  It seems to be a band-aid to
>>> cover up a problem in the i2c master device driver code.
>>
>> Yes it is I2C provider limitation, but I think almost all I2C adapters have
>> some limit. I suggest to set param for each tuner and demod driver which
>> splits reads and writes to len adapter can handle. I did that for tda18218
>> write.
>>
>> But there is one major point you don't see. It is not simple to add this
>> splitting limit to the provider. Provider does not have knowledge which is
>> meaning of bytes it transfers to the bus. Without knowledge it breaks
>> functionality surely in some point. There is commonly seen 1, 2 and 4 byte
>> register address and same for register values. Also some chips like to send
>> data as register-value pairs.
> 
> Yes, I understand.  We will likely merge Mauro's patch, I just want to
> test it on my own hardware first, and I'd like to verify the cx231xx
> i2c xfer limit issue that Mauro is reporting.  I'll try to get back to
> this early next week, or hopefully over this weekend.

Feel free to test. Just remember that all Hauppauge devices at Devin's polaris4
tree uses I2C Channel #1. This seems to be the default on all Conexant SDK also. 
The device I'm working with has the tuner at channel #2, and the ISDB-T demod
at channel #1. So, the limits may differ.

On my device, everything seem to work fine with max size = 4 
(both analog and digital modes).

Cheers,
Mauro

