Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:19726 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZCRJIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 05:08:44 -0400
Received: by yw-out-2324.google.com with SMTP id 3so441184ywj.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 02:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237361875.5382.9.camel@iivanov.int.mm-sol.com>
References: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
	 <1237361875.5382.9.camel@iivanov.int.mm-sol.com>
Date: Wed, 18 Mar 2009 18:08:41 +0900
Message-ID: <5e9665e10903180208n52d596f6ga5cc16f5f765ee5d@mail.gmail.com>
Subject: Re: About white balance control.
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	bill@thedirks.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivan,


2009/3/18 Ivan T. Ivanov <iivanov@mm-sol.com>:
>  Hi Kim,
>
> On Wed, 2009-03-18 at 13:32 +0900, Dongsoo, Nathaniel Kim wrote:
>> Hello,
>>
>> I accidently realized today that I was using white balance control in wrong way.
>>
>> As far as I understand we've got
>>
>> V4L2_CID_AUTO_WHITE_BALANCE which activate auto white balance
>> adjustment in runtime,
>> V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE specifying absolute kelvin value
>>
>> but can't get what V4L2_CID_DO_WHITE_BALANCE is for.
>
>  My understanding is that V4L2_CID_DO_WHITE_BALANCE enable/disable
>  white balance processing, while with
>  V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE you can specify explicitly
>  ambient temperature.

OK, then according to your explanation DO_WHITE_BALANCE is only for
AUTO_WHITE_BALANCE. Am I following?
Because only auto white balance mode does processing and make changes
in color temperature while preview is working.

>
>>
>> I think after issuing V4L2_CID_AUTO_WHITE_BALANCE and
>> V4L2_CID_WHITE_BALANCE_TEMPERATURE,
>> the white balance functionality works immediately. Isn't it right?
>>
>> What exactly is the button type V4L2_CID_DO_WHITE_BALANCE for? Because
>> the V4L2 API document says that "(the value is ignored)". Does that
>> mean that even we have issued V4L2_CID_AUTO_WHITE_BALANCE and
>> V4L2_CID_WHITE_BALANCE_TEMPERATURE, we can't see the white balance
>> working at that moment?
>>
>> And one more thing. If I want to serve several white balance presets,
>> like cloudy, dawn, sunny and so on, what should I do?
>> I think it should be supported as menu type, but most of drivers are
>> using white balance CID with integer type...then what should I do?
>> Define preset names with kelvin number like this?
>
>  I also will like to see controls which specify different kind of
>  white balance mode (cloudy, sunny, tungsten...). in this case
>  we can thing about V4L2_CID_WHITE_BALANCE_TEMPERATURE as 'manual'
>  mode, and let other modes to be handled by some clever algorithms ;).
>

If there isn't any driver which is driving white balance with menu
type, there should be some reason for that.
I want to make it clear if I could. I hope Hans or other maintainer
could answer this.
Cheers,

Nate

>  IIvanov
>
>
>>
>> #define WB_CLOUDY 8000
>>
>> Pretty confusing... anyone knows what should I do?
>>
>> Nate
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
