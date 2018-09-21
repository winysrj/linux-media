Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:22614 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbeIUObj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 10:31:39 -0400
Subject: Re: [PATCH v5] media: add imx319 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: bingbu.cao@intel.com, linux-media@vger.kernel.org,
        tfiga@google.com, rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com
References: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
 <20180917113413.n6hd5suldwuspio3@paasikivi.fi.intel.com>
 <ba2ba184-9bc2-869c-24d2-edfd6b796d2c@linux.intel.com>
 <20180921074133.qx3tje7h6kws4vxg@kekkonen.localdomain>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <75e61fc3-734f-bd22-32a9-6347f0a81bed@linux.intel.com>
Date: Fri, 21 Sep 2018 16:47:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180921074133.qx3tje7h6kws4vxg@kekkonen.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/21/2018 03:41 PM, Sakari Ailus wrote:
> Hi Bingbu,
>
> On Fri, Sep 21, 2018 at 03:20:19PM +0800, Bing Bu Cao wrote:
> ...
>>>> +	try_fmt->field = V4L2_FIELD_NONE;
>>>> +
>>>> +	mutex_unlock(&imx319->mutex);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int imx319_update_digital_gain(struct imx319 *imx319, u32 d_gain)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = imx319_write_reg(imx319, IMX319_REG_DPGA_USE_GLOBAL_GAIN, 1, 1);
>>>> +	if (ret)
>>>> +		return ret;
>>> You could do this write right after powering the sensor on, couldn't you?
>> Sakari,
>> Use IMX319_REG_DPGA_USE_GLOBAL_GAIN to do digital gain control, 1 for all
>> color and 0 for by color. For all color, use register
>> IMX319_REG_DIG_GAIN_GLOBAL to set the digital gain value, otherwise use
>> other registers below. By default the digital gain select is not set and
>> the gain will be set by color via setting register 0x0210, 0x0212,
>> 0x0213, these registers were set during powering on. So I prefer to only
>> change the default digital gain control if any digital gain request.
>>
>> Does this make sense?
> Why are per-component gains used at all when they always have the same
> value and the sensor supports global gain?
I see that both the per-color and all-color gains are set during powering on.
I think they are from the reference settings from vendor, let me try to move
this control selection into streaming ops.

Thanks!
>
