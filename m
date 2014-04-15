Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61847 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDOO3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 10:29:32 -0400
Message-id: <534D4245.2040901@samsung.com>
Date: Tue, 15 Apr 2014 16:29:25 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Rahul Sharma <r.sh.open@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>, b.zolnierkie@samsung.com,
	"sw0312.kim" <sw0312.kim@samsung.com>,
	sunil joshi <joshi@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	m.chehab@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Rahul Sharma <rahul.sharma@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 4/4] drm: exynos: hdmi: add support for pixel clock
 limitation
References: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
 <1397554040-4037-5-git-send-email-t.stanislaws@samsung.com>
 <CAPdUM4NysWMpy3PZhJdKXFa96Oy4kG4dKkDdrabbAmM3+f5kag@mail.gmail.com>
 <534D3001.2030707@samsung.com>
 <CAPdUM4PCDC8J5k2uNv6DYf8FzXKcNcm7JQZ-cbAzmXzx9YDAAw@mail.gmail.com>
In-reply-to: <CAPdUM4PCDC8J5k2uNv6DYf8FzXKcNcm7JQZ-cbAzmXzx9YDAAw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2014 03:42 PM, Rahul Sharma wrote:
> On 15 April 2014 18:41, Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
>> On 04/15/2014 11:42 AM, Rahul Sharma wrote:
>>> Hi Tomasz,
>>>
>>> On 15 April 2014 14:57, Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
>>>> Adds support for limitation of maximal pixel clock of HDMI
>>>> signal. This feature is needed on boards that contains
>>>> lines or bridges with frequency limitations.
>>>>
>>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
[snip]

>>>> diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
>>>> index 181642b..7272d65 100644
>>>> --- a/include/media/s5p_hdmi.h
>>>> +++ b/include/media/s5p_hdmi.h
>>>> @@ -31,6 +31,7 @@ struct s5p_hdmi_platform_data {
>>>>         int mhl_bus;
>>>>         struct i2c_board_info *mhl_info;
>>>>         int hpd_gpio;
>>>> +       u32 max_pixel_clock;
>>>>  };
>>>
>>> We have already removed Non DT support from the drm hdmi
>>> driver. IMO we should not be extending the pdata struct.
>>>
>>> Regards,
>>> Rahul Sharma
>>
>> Hi Rahul,
>>
>> This is not a non-DT patch. The s5p_hdmi_platform_data is
>> generated from DT itself. This structure is just
>> a parsed version of DT attributes.
>>
>> It may be a good idea to rename s5p_hdmi_platform_data
>> to exynos_hdmi_pdata and move it to exynos_hdmi_drm.c file
>> or parse DT directly in probe function.
>>
>> I can prepare a patch for that.
> 
> Else we can completely remove the dependency from
> s5p_hdmi_platform_data. We can directly assign to hdmi context
> variables. Later we can remove that struct itself from include/.
> What you say?

This structure cannot be removed from include yet because it is used by s5p-tv driver.
However its usage can be removed from both drivers.
I can prepare both.

> 
> Regards,
> Rahul Sharma
> 

Regards,
Tomasz Stanislawski

>>
>> Regards,
>> Tomasz Stanislawski
>>
>>
>>>
>>>>
>>>>  #endif /* S5P_HDMI_H */
>>>> --
>>>> 1.7.9.5
>>>>
>>>> _______________________________________________
>>>> dri-devel mailing list
>>>> dri-devel@lists.freedesktop.org
>>>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>>
> 

