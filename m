Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51707 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaCJKBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 06:01:31 -0400
Message-ID: <531D8D78.800@iki.fi>
Date: Mon, 10 Mar 2014 12:01:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 11/13] DocBook: document RF tuner bandwidth controls
References: <1393460528-11684-1-git-send-email-crope@iki.fi> <1393460528-11684-12-git-send-email-crope@iki.fi> <20140305154922.508c48d7@samsung.com>
In-Reply-To: <20140305154922.508c48d7@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.03.2014 20:49, Mauro Carvalho Chehab wrote:
> Em Thu, 27 Feb 2014 02:22:06 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Add documentation for RF tuner bandwidth controls. These controls are
>> used to set filters on tuner signal path.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 6c9dbf6..5550fea 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -5007,6 +5007,25 @@ descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
>>   description of this control class.</entry>
>>               </row>
>>               <row>
>> +              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_BANDWIDTH_AUTO</constant>&nbsp;</entry>
>> +              <entry>boolean</entry>
>> +            </row>
>> +            <row>
>> +              <entry spanname="descr">Enables/disables tuner radio channel
>> +bandwidth configuration. In automatic mode bandwidth configuration is performed
>> +by the driver.</entry>
>> +            </row>
>> +            <row>
>> +              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_BANDWIDTH</constant>&nbsp;</entry>
>> +              <entry>integer</entry>
>> +            </row>
>> +            <row>
>> +              <entry spanname="descr">Filter(s) on tuner signal path are used to
>> +filter signal according to receiving party needs. Driver configures filters to
>> +fulfill desired bandwidth requirement. Used when V4L2_CID_RF_TUNER_BANDWIDTH_AUTO is not
>> +set. The range and step are driver-specific.</entry>
>
> Huh? If this is enable/disable, why "the range and step are driver-specific"?

Because there is two controls grouped. That is situation of having 
AUTO/MANUAL.
V4L2_CID_RF_TUNER_BANDWIDTH_AUTO
V4L2_CID_RF_TUNER_BANDWIDTH

V4L2_CID_RF_TUNER_BANDWIDTH is valid only when 
V4L2_CID_RF_TUNER_BANDWIDTH_AUTO == false.

regards
Antti



>
>> +            </row>
>> +            <row>
>>                 <entry spanname="id"><constant>V4L2_CID_RF_TUNER_LNA_GAIN_AUTO</constant>&nbsp;</entry>
>>                 <entry>boolean</entry>
>>               </row>
>
>


-- 
http://palosaari.fi/
