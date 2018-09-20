Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbeIUCCD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:02:03 -0400
From: Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
To: tfiga@chromium.org
Cc: Grant Grundler <grundler@chromium.org>, ping-chung.chen@intel.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, andy.yeh@intel.com, jim.lai@intel.com,
        Rajmohan Mani <rajmohan.mani@intel.com>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
 <CANEJEGvZn7oSdtYcwb4qxqiys1_y6GPh+1fZUfdejg2ztSsRmw@mail.gmail.com>
Message-ID: <4e3e21d3-21f7-48eb-7672-f157c1a4fdcc@kernel.org>
Date: Thu, 20 Sep 2018 22:16:47 +0200
MIME-Version: 1.0
In-Reply-To: <CANEJEGvZn7oSdtYcwb4qxqiys1_y6GPh+1fZUfdejg2ztSsRmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2018 06:49 PM, Grant Grundler wrote:
> On Thu, Sep 20, 2018 at 1:52 AM Tomasz Figa <tfiga@chromium.org> wrote:
>> On Wed, Aug 8, 2018 at 4:08 PM Ping-chung Chen
>> <ping-chung.chen@intel.com> wrote:

>>> +/* Digital gain control */

>>> +#define IMX208_DGTL_GAIN_MIN           0
>>> +#define IMX208_DGTL_GAIN_MAX           4096
>>> +#define IMX208_DGTL_GAIN_DEFAULT       0x100
>>> +#define IMX208_DGTL_GAIN_STEP           1

>>> +/* Initialize control handlers */
>>> +static int imx208_init_controls(struct imx208 *imx208)
>>> +{
>> [snip]
>>> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
>>> +                         IMX208_DGTL_GAIN_MIN, IMX208_DGTL_GAIN_MAX,
>>> +                         IMX208_DGTL_GAIN_STEP,
>>> +                         IMX208_DGTL_GAIN_DEFAULT);
>>
>> We have a problem here. The sensor supports only a discrete range of
>> values here - {1, 2, 4, 8, 16} (multiplied by 256, since the value is
>> fixed point). This makes it possible for the userspace to set values
>> that are not allowed by the sensor specification and also leaves no
>> way to enumerate the supported values.

The driver could always adjust the value in set_ctrl callback so invalid
settings are not allowed.

I'm not sure if it's best approach but I once did something similar for
the ov9650 sensor. The gain was fixed point 10-bits value with 4 bits
for fractional part. The driver reports values multiplied by 16. See 
ov965x_set_gain() function in drivers/media/i2c/ov9650.c and "Table 4-1.
Total Gain to Control Bit Correlation" in the OV9650 datasheet for details. 
The integer menu control just seemed not suitable for 2^10 values. 
Now the gain control has range 16...1984 out of which only 1024 values 
are valid. It might not be best approach for a GUI but at least the driver 
exposes mapping of all valid values, which could be enumerated with 
VIDIOC_TRY_EXT_CTRLS if required, without a need for a driver-specific 
user space code.  

>> I can see two solutions here:
>>
>> 1) Define the control range from 0 to 4 and treat it as an exponent of
>> 2, so that the value for the sensor becomes (1 << val) * 256.
>> (Suggested by Sakari offline.)
>>
>> This approach has the problem of losing the original unit (and scale)
>> of the value.
> 
> Exactly - will users be confused by this? If we have to explain it,
> probably not the best choice.
> 
>>
>> 2) Use an integer menu control, which reports only the supported
>> discrete values - {1, 2, 4, 8, 16}.
>>
>> With this approach, userspace can enumerate the real gain values, but
>> we would either need to introduce a new control (e.g.
>> V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
>> register V4L2_CID_DIGITAL_GAIN as an integer menu.
>>
>> Any opinions or better ideas?
> 
> My $0.02: leave the user UI alone - let users specify/select anything
> in the range the normal API or UI allows. But have sensor specific
> code map all values in that range to values the sensor supports. Users
> will notice how it works when they play with it.  One can "adjust" the
> mapping so it "feels right".

--
Regards,
Sylwester
