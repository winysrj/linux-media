Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34796 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbbJZIV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 04:21:27 -0400
Received: by oies66 with SMTP id s66so96012314oie.1
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2015 01:21:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562DDBE2.80504@intel.com>
References: <CALxjpLP7jPBTvbMsJFMU+GgJo8i37WcfwLPxJL6+27jpJd0Ukw@mail.gmail.com>
 <562DDBE2.80504@intel.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Mon, 26 Oct 2015 09:21:07 +0100
Message-ID: <CAH-u=81N45XhXUiaPQG4u-DyNiNd65L-eb=ae7z4UYdLGmib-Q@mail.gmail.com>
Subject: Re: Is IIO the appropriate subsystem for a thermal camera sensor?
To: Daniel Baluta <daniel.baluta@intel.com>
Cc: Lucas Magasweran <lucas.magasweran@daqri.com>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lucas,

2015-10-26 8:53 GMT+01:00 Daniel Baluta <daniel.baluta@intel.com>:
> Hi Lucas,
>
> Adding linux-iio and linux-media, I hope you don't mind.
>
> On 10/23/2015 06:58 PM, Lucas Magasweran wrote:
>>
>> Hi Daniel,
>>
>> My colleague, Roberto Cornetti, attended your IIO talk at LinuxCon
>> recently and is using the IIO subsystem for an I2C IMU.
>>
>
> Glad to hear that :)
>
>> My question is if IIO the appropriate subsystem for a thermal camera
>> sensor. The driver needs to acquire frames over SPI and configure the
>> sensor via I2C. It also has to respond to a GPIO interrupt to
>> synchronize with the camera.
>
>
> I am not sure exactly about this. My feeling is that this should go with the
> v4l subsystem thus Cc-ing linux-media.

This is definitely a V4L2 driver. Note however that AFAIK, no sensor
is currently sending frames from SPI right now... Nothing impossible
though :).

> Do you have any datasheet for this sensor?
>
> At some point [1] we considered introducing the fingerprint sensor as an IIO
> device, but that didn't quite fit. So, we reconsidered using v4l.
> I this is your case too :).
>
> Hope this helps.
> Daniel.
>
>
> [1] http://marc.info/?l=linux-kernel&m=141769805614596&w=2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
