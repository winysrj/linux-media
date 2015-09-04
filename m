Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34793 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843AbbIDTYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 15:24:25 -0400
Subject: Re: [PATCH 13/13] DocBook: add SDR specific info to G_MODULATOR /
 S_MODULATOR
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1441144769-29211-1-git-send-email-crope@iki.fi>
 <1441144769-29211-14-git-send-email-crope@iki.fi>
 <55E971EF.3070901@xs4all.nl>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55E9EFE6.7040506@iki.fi>
Date: Fri, 4 Sep 2015 22:24:22 +0300
MIME-Version: 1.0
In-Reply-To: <55E971EF.3070901@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2015 01:26 PM, Hans Verkuil wrote:
> On 09/01/2015 11:59 PM, Antti Palosaari wrote:
>> Add SDR specific notes to G_MODULATOR / S_MODULATOR documentation.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
>> index 80167fc..affb694 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
>> @@ -78,6 +78,15 @@ different audio modulation if the request cannot be satisfied. However
>>   this is a write-only ioctl, it does not return the actual audio
>>   modulation selected.</para>
>>
>> +    <para><link linkend="sdr">SDR</link> specific modulator types are
>> +<constant>V4L2_TUNER_SDR</constant> and <constant>V4L2_TUNER_RF</constant>.
>> +Valid fields for these modulator types are <structfield>index</structfield>,
>> +<structfield>name</structfield>, <structfield>capability</structfield>,
>> +<structfield>rangelow</structfield>, <structfield>rangehigh</structfield>
>> +and <structfield>type</structfield>. All the rest fields must be
>
> s/rest/remaining/
>
>> +initialized to zero by both application and driver.
>
> I would drop this sentence. The spec is clear about which fields have to be set
> by the user. The only thing I would mention here is that txsubchans should be
> initialized to 0 by applications (we might want to use it in the future) when
> calling S_MODULATOR.
>
> For S_TUNER it is the same: only mention that audmode should be initialized to
> 0 for these SDR tuner types.
>
>> +Term modulator means SDR transmitter on this context.</para>
>
> s/Term/The term/
> s/on/in/
>
> Note: the same typos are in patch 12/13.
>
> Perhaps this sentence should be rewritten since it is not clear what you
> mean. I guess the idea is that 'modulator' is not a good match to what actually
> happens in the SDR hardware?
>
> How about:
>
> "Note that the term 'modulator' is a misnomer for type V4L2_TUNER_SDR since
> this really is a DAC and the 'modulator' frequency is in reality the sampling
> frequency of the DAC."
>
> I hope I got that right.
>
> And do something similar for patch 12/13.

I added it mainly because struct v4l2_modulator is somehow misleading as 
it contains both modulator and RF frontend specific stuff and especially 
misleading for SDR case as modulator is located in a host computer 
software. On DVB side modulator/demodulator and tuner are split more 
correctly.

If you look that struct v4l2_modulator:
index: common field
name: common field
capability: contains both RF frontend and modulator stuff
rangelow: RF frontend specific
rangehigh: RF frontend specific
txsubchans: modulator specific
type: common field
reserved: reserved

So actually most field on that struct v4l2_modulator are RF frontend 
specific, not modulator. Same applies to struct v4l2_tuner.

These should be probably:
tuner => receiver
modulator => transmitter

Or even better, like DVB side, split modulator/demodulator and RF stuff 
to own structs. But as it is not reasonable to start changing those, so 
I decided to add comment for tuner that it means SDR receiver and for 
modulator it means SDR transmitter.

regards
Antti

>
>> +
>>       <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
>>   is available.</para>
>>
>>
>
> Regards,
>
> 	Hans
>

-- 
http://palosaari.fi/
