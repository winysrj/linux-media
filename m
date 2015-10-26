Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5150 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbbJZHua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 03:50:30 -0400
Message-ID: <562DDBE2.80504@intel.com>
Date: Mon, 26 Oct 2015 09:53:06 +0200
From: Daniel Baluta <daniel.baluta@intel.com>
MIME-Version: 1.0
To: Lucas Magasweran <lucas.magasweran@daqri.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Is IIO the appropriate subsystem for a thermal camera sensor?
References: <CALxjpLP7jPBTvbMsJFMU+GgJo8i37WcfwLPxJL6+27jpJd0Ukw@mail.gmail.com>
In-Reply-To: <CALxjpLP7jPBTvbMsJFMU+GgJo8i37WcfwLPxJL6+27jpJd0Ukw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lucas,

Adding linux-iio and linux-media, I hope you don't mind.

On 10/23/2015 06:58 PM, Lucas Magasweran wrote:
> Hi Daniel,
>
> My colleague, Roberto Cornetti, attended your IIO talk at LinuxCon
> recently and is using the IIO subsystem for an I2C IMU.
>

Glad to hear that :)

> My question is if IIO the appropriate subsystem for a thermal camera
> sensor. The driver needs to acquire frames over SPI and configure the
> sensor via I2C. It also has to respond to a GPIO interrupt to
> synchronize with the camera.

I am not sure exactly about this. My feeling is that this should go with 
the v4l subsystem thus Cc-ing linux-media.

Do you have any datasheet for this sensor?

At some point [1] we considered introducing the fingerprint sensor as an 
IIO device, but that didn't quite fit. So, we reconsidered using v4l.
I this is your case too :).

Hope this helps.
Daniel.


[1] http://marc.info/?l=linux-kernel&m=141769805614596&w=2



