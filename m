Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59996 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2HCUlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 16:41:53 -0400
Received: by weyx8 with SMTP id x8so687706wey.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 13:41:52 -0700 (PDT)
Message-ID: <501C378E.7060903@gmail.com>
Date: Fri, 03 Aug 2012 22:41:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATH v3 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with
 embedded SoC ISP
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org> <501ADEF6.1080901@gmail.com> <CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
In-Reply-To: <CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 08/03/2012 04:24 PM, Sangwook Lee wrote:
> Hi  Sylwester
> 
> Thank you for the review.
> 
> On 2 August 2012 21:11, Sylwester Nawrocki<sylvester.nawrocki@gmail.com>  wrote:
>> On 08/02/2012 03:42 PM, Sangwook Lee wrote:
>>> The following 2 patches add driver for S5K4ECGX sensor with embedded ISP SoC,
>>> and minor v4l2 control API enhancement. S5K4ECGX is 5M CMOS Image sensor from Samsung
>>>
>>> Changes since v2:
>>> - added GPIO (reset/stby) and regulators
>>> - updated I2C read/write, based on s5k6aa datasheet
>>> - fixed set_fmt errors
>>> - reduced register tables a bit
>>> - removed vmalloc
>>
>> It looks like a great improvement, well done! Thanks!
>>
>> In the S5K4CAGX sensor datasheet, that can be found on the internet,
>> there is 0x0000...0x002E registers description, which look very much
>> same as in S5K6AAFX case and likely is also valid for S5K4CAGX.
> 
> 
> [snip]
> 
>>
>>
>> What do you think about converting s5k4ecgx_img_regs arrays (it has
>> over 2700 entries) to a firmware file and adding some simple parser
>> to the driver ? Then we would have the problem solved in most part.
>>
> 
> Thanks, fair enough. let me try this.

All right, thanks.

>> Regarding various preview resolution set up, the difference in all
>> those s5k4ecgx_*_preview[] arrays is rather small, only register
>> values differ, e.g. for 640x480 and 720x480 there is only 8 different
>> entries:
>>
> 
> Ok, let me reduce table size again.

I don't think it's worth the effort to work around those tables.
They may just be removed entirely. I'll see if I can find time to
prepare a function replacing them. All required information seems
to be available in the datasheet.

>> $ diff -a s5k4ec_640.txt s5k4ec_720.txt
>> 1c1
>> <  static const struct regval_list s5k4ecgx_640_preview[] = {
>> ---
>>> static const struct regval_list s5k4ecgx_720_preview[] = {
>> 3c3
>> <        { 0x70000252, 0x0780 },
>> ---
>>>        { 0x70000252, 0x06a8 },
>> 5c5
> 
> [snip]
> 
>> <        { 0x70000256, 0x000c },
>>>        { 0x700002a6, 0x02d
> 
> [snip]
>>
>> Could you please try to implement a function that replaces those tables,
>> based s5k6aa_set_prev_config() and s5k6aa_set_output_framefmt() ?
>>
> I was thinking about this, but this seems to be is a bit time-consuming because
> I have to do this just due to lack of s5k4ecgx hardware information.
> let me try it later once
> this patch is accepted.

Yes, I know it's not trivial and requires some work... Let me try
to cook up something myself, as I have already some experience with 
S5K6AAFX. Those "firmware" arrays are evil, and no good driver shall
rely on them.. :-)

And we have plenty time now, until v3.7 merge window.

--

Regards,
Sylwester
