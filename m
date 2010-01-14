Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:39883 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757167Ab0ANRZV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 12:25:21 -0500
Message-ID: <4B4F537B.7000708@panicking.kicks-ass.org>
Date: Thu, 14 Jan 2010 18:25:15 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap34xxcam question?
References: <4B4F0762.4040007@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Aguirre, Sergio wrote:
> 
>> -----Original Message-----
>> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
>> Sent: Thursday, January 14, 2010 6:01 AM
>> To: linux-media@vger.kernel.org
>> Cc: Aguirre, Sergio
>> Subject: omap34xxcam question?
>>
>> Hi
>>
>> Is ok that it try only the first format and size? why does it not continue
>> and find a matching?
> 
> Actually, that was the intention, but I guess it was badly implemented.
> 
> Thanks for the catch, and the contribution!
> 
> Regards,
> Sergio
>> @@ -470,7 +471,7 @@ static int try_pix_parm(struct omap34xxcam_videodev
>> *vdev,
>>                         pix_tmp_out = *wanted_pix_out;
>>                         rval = isp_try_fmt_cap(isp, &pix_tmp_in,
>> &pix_tmp_out);
>>                         if (rval)
>> -                               return rval;
>> +                               continue;
>>

Is the patch good? or you are going to provide a better fix

Michael

>> Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

