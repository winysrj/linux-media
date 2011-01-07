Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51942 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1AGOU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 09:20:26 -0500
Received: by ewy5 with SMTP id 5so7812433ewy.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 06:20:25 -0800 (PST)
Message-ID: <4D2720E7.3000209@mvista.com>
Date: Fri, 07 Jan 2011 17:19:19 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"linux-arm-kernel@listinfradead.com"
	<linux-arm-kernel@listinfradead.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v12 5/8] davinci vpbe: platform specific additions
References: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81F@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81F@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 07-01-2011 17:13, Hadli, Manjunath wrote:

>>> This patch implements the overall device creation for the Video
>>> display driver.

>>> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
>>> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
>>> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
>> [...]

>>> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h
>>> b/arch/arm/mach-davinci/include/mach/dm644x.h
>>> index 5a1b26d..b59591c 100644
>>> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
>>> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
[...]
>>> @@ -40,8 +43,21 @@
>>>    #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
>>>    #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000

>>> +/* VPBE register base addresses */
>>> +#define DM644X_VENC_REG_BASE		0x01C72400

>>      You defined the macro but don't use it...

>>> +#define DM644X_VPBE_REG_BASE		0x01C72780
>>> +
>>> +#define DM644X_OSD_REG_BASE		0x01C72600

>>      Same comment...

>>> +#define DM644X_VPBE_REG_BASE		0x01C72780

>>      This is duplicate.

>>> +
>>> +#define OSD_REG_SIZE			0x00000100

>>      Your OSD platform device however has its resource of size 0x200...

>>> +/* SYS register addresses */
>>> +#define SYS_VPSS_CLKCTL			0x01C40044

>>      You've already #define'd and used VPSS_CLKCTL -- this is duplicate/unused.

> We are using the base addresses from platform resources. I will delete these.

    You could use these macros to #define the platfrom resources, if you 
#define'd them already.

WBR, Sergei
