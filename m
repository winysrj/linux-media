Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0CRMHI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 08:07:08 -0400
Message-ID: <4BA21766.7010007@redhat.com>
Date: Thu, 18 Mar 2010 09:07:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] Add a macro to properly create IR tables
References: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com> <636219277bb150426e3219e48d30138f00b8a52e.1268440758.git.mchehab@redhat.com> <A24693684029E5489D1D202277BE8944541CC708@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944541CC708@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> Hi Mauro,
> 
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
>> Sent: Friday, March 12, 2010 8:40 AM
>> To: Linux Media Mailing List
>> Subject: [PATCH 2/4] Add a macro to properly create IR tables
> 
> This one is missing it's respective "V4L2/DVB:" prefix, as the other patches
> In the series has.

Thanks, Sergio. I've already fixed it when I've applied the patch:

Subject: V4L/DVB: ir-core: Add a macro to properly create IR tables
Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
Date:    Fri Mar 12 11:40:13 2010 -0300

I generally review the subjects and the comments during the patch import procedure,
fixing them when needed.

(btw, the name of the affected file were also missed on the patch I've posted).
> 
> Regards,
> Sergio
> 
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
> 
> <snip>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
