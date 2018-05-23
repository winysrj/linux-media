Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41880 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932313AbeEWJcC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 05:32:02 -0400
Subject: Re: [PATCH v3 03/12] media: ov5640: Remove the clocks registers
 initialization
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Sam Bobrowicz <sam@elite-embedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com>
 <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
 <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
 <20180521073902.ayky27k5pcyfyyvc@flea> <20180522195437.bay6muqp3uqq5k3z@flea>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <f4948940-c3e1-5464-c012-e4d6ca196cdd@zonque.org>
Date: Wed, 23 May 2018 11:31:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180522195437.bay6muqp3uqq5k3z@flea>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Tuesday, May 22, 2018 09:54 PM, Maxime Ripard wrote:
> On Mon, May 21, 2018 at 09:39:02AM +0200, Maxime Ripard wrote:
>> On Fri, May 18, 2018 at 07:42:34PM -0700, Sam Bobrowicz wrote:

>>> This set of patches is also not working for my MIPI platform (mine has
>>> a 12 MHz external clock). I am pretty sure is isn't working because it
>>> does not include the following, which my tests have found to be
>>> necessary:
>>>
>>> 1) Setting pclk period reg in order to correct DPHY timing.
>>> 2) Disabling of MIPI lanes when streaming not enabled.
>>> 3) setting mipi_div to 1 when the scaler is disabled
>>> 4) Doubling ADC clock on faster resolutions.
>>
>> Yeah, I left them out because I didn't think this was relevant to this
>> patchset but should come as future improvements. However, given that
>> it works with the parallel bus, maybe the two first are needed when
>> adjusting the rate.
> 
> I've checked for the pclk period, and it's hardcoded to the same value
> all the time, so I guess this is not the reason it doesn't work on
> MIPI CSI anymore.
> 
> Daniel, could you test:
> http://code.bulix.org/ki6kgz-339327?raw

[Note that there's a missing parenthesis in this snippet]

Hmm, no, that doesn't change anything. Streaming doesn't work here, even 
if I move ov5640_load_regs() before any other initialization.

One of my test setup is the following gst pipeline:

   gst-launch-1.0	\
	v4l2src device=/dev/video0 ! \
	videoconvert ! \
	video/x-raw,format=UYVY,width=1920,height=1080 ! \
	glimagesink

With the pixel clock hard-coded to 166600000 in qcom camss, the setup 
works on 4.14, but as I said, it broke already before this series with 
5999f381e023 ("media: ov5640: Add horizontal and vertical
totals").

Frankly, my understanding of these chips is currently limited, so I 
don't really know where to start digging. It seems clear though that the 
timing registers setup is necessary for other register writes to succeed.

Can I help in any other way?


Thanks for all your efforts,
Daniel
