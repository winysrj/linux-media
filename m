Return-path: <linux-media-owner@vger.kernel.org>
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36631 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbbJZKXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 06:23:07 -0400
In-Reply-To: <CAH-u=81N45XhXUiaPQG4u-DyNiNd65L-eb=ae7z4UYdLGmib-Q@mail.gmail.com>
References: <CALxjpLP7jPBTvbMsJFMU+GgJo8i37WcfwLPxJL6+27jpJd0Ukw@mail.gmail.com> <562DDBE2.80504@intel.com> <CAH-u=81N45XhXUiaPQG4u-DyNiNd65L-eb=ae7z4UYdLGmib-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Is IIO the appropriate subsystem for a thermal camera sensor?
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Date: Mon, 26 Oct 2015 10:22:58 +0000
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
	Daniel Baluta <daniel.baluta@intel.com>
CC: Lucas Magasweran <lucas.magasweran@daqri.com>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <AB8AAEEE-A162-439C-8111-766AF4CAE33C@jic23.retrosnub.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 26 October 2015 08:21:07 GMT+00:00, Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com> wrote:
>Hi Lucas,
>
>2015-10-26 8:53 GMT+01:00 Daniel Baluta <daniel.baluta@intel.com>:
>> Hi Lucas,
>>
>> Adding linux-iio and linux-media, I hope you don't mind.
>>
>> On 10/23/2015 06:58 PM, Lucas Magasweran wrote:
>>>
>>> Hi Daniel,
>>>
>>> My colleague, Roberto Cornetti, attended your IIO talk at LinuxCon
>>> recently and is using the IIO subsystem for an I2C IMU.
>>>
>>
>> Glad to hear that :)
>>
>>> My question is if IIO the appropriate subsystem for a thermal camera
>>> sensor. The driver needs to acquire frames over SPI and configure
>the
>>> sensor via I2C. It also has to respond to a GPIO interrupt to
>>> synchronize with the camera.
>>
>>
>> I am not sure exactly about this. My feeling is that this should go
>with the
>> v4l subsystem thus Cc-ing linux-media.
>
>This is definitely a V4L2 driver. Note however that AFAIK, no sensor
>is currently sending frames from SPI right now... Nothing impossible
>though :).

Absolutely agree. The confusion on this probably stems from thermopiles
 (which are kind of single pixel thermal cameras) and higher res thermal
 cameras.  If you think of it as the same an ambient light sensor vs an optical
 camera then the divisions become clearer.

There are very low pixel count thermal cameras that blur the boundaries though
 so I guess you may have one of those? 4x4 for example.  I still think these should
 be v4l.  Kind of dependent on whether the output is 2d or 1d to my mind.

Jonathan
>
>> Do you have any datasheet for this sensor?
>>
>> At some point [1] we considered introducing the fingerprint sensor as
>an IIO
>> device, but that didn't quite fit. So, we reconsidered using v4l.
>> I this is your case too :).
>>
>> Hope this helps.
>> Daniel.
>>
>>
>> [1] http://marc.info/?l=linux-kernel&m=141769805614596&w=2
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
