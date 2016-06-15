Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35541 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbcFOTYp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 15:24:45 -0400
Subject: Re: [PATCH v3 2/2] media: et8ek8: Add documentation
To: Rob Herring <robh@kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1465659593-16858-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160614220517.GA23504@rob-hp-laptop>
 <20160615043116.GG26360@valkosipuli.retiisi.org.uk>
 <CAL_JsqKDxnc-pTOcdbL4iWFB9qU5924N0TV0NFw=A-zGN8boXQ@mail.gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>,
	=?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5761AB78.2030707@gmail.com>
Date: Wed, 15 Jun 2016 22:24:40 +0300
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKDxnc-pTOcdbL4iWFB9qU5924N0TV0NFw=A-zGN8boXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 15.06.2016 21:41, Rob Herring wrote:
> On Tue, Jun 14, 2016 at 11:31 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Hi Rob,
>>
>> On Tue, Jun 14, 2016 at 05:05:17PM -0500, Rob Herring wrote:
>>> On Sat, Jun 11, 2016 at 06:39:53PM +0300, Ivaylo Dimitrov wrote:
>>>> Add DT bindings description
>>>
>>> Not exactly the best commit msg.
>>>

will elaborate a bit more in the next patch version

>>>>
>>>> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>>>> ---
>>>>   .../bindings/media/i2c/toshiba,et8ek8.txt          | 50 ++++++++++++++++++++++
>>>>   1 file changed, 50 insertions(+)
>>>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>>>> new file mode 100644
>>>> index 0000000..997d268
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>>>> @@ -0,0 +1,50 @@
>>>> +Toshiba et8ek8 5MP sensor
>>>> +
>>>> +Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
>>>> +
>>>> +More detailed documentation can be found in
>>>> +Documentation/devicetree/bindings/media/video-interfaces.txt .
>>>> +
>>>> +
>>>> +Mandatory properties
>>>> +--------------------
>>>> +
>>>> +- compatible: "toshiba,et8ek8"
>>>> +- reg: I2C address (0x3e, or an alternative address)
>>>> +- vana-supply: Analogue voltage supply (VANA), 2.8 volts
>>>
>>>> +- clocks: External clock to the sensor
>>>> +- clock-frequency: Frequency of the external clock to the sensor
>>>
>>> These should be mutually-exclusive. If you have a clock, then you can
>>> get the frequency at runtime.
>>
>> Yes, you can. But the intention is to set the frequency: the sensor requires
>> a particular, pre-determined frequency. Typically this is specific to the
>> board.
>
> Okay, then state that in the description.
>

ok, will do in the next patch version

Thanks,
Ivo
