Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:20051 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932210AbdACJM2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 04:12:28 -0500
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Subject: Re: [PATCH v1] [media] v4l2-common: fix aligned value calculation
Date: Tue, 3 Jan 2017 09:12:20 +0000
Message-ID: <43f5ee50-f737-c454-3034-f153fa6f799a@st.com>
References: <1481895135-11055-1-git-send-email-jean-christophe.trotin@st.com>
 <20161216135626.GK16630@valkosipuli.retiisi.org.uk>
In-Reply-To: <20161216135626.GK16630@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <DDF395F4D6C0E64C8D1AC4B7DDA8DE6F@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for your answer.
You're right: the modification that I proposed, is not correct (I misunderstood 
the aim of the function); the current clamp_align() is correct and doesn't need 
any modification.
Thus, the patch that I sent, must be ignored.
Sorry for the disruption.

Regards,
Jean-Christophe.


On 12/16/2016 02:56 PM, Sakari Ailus wrote:
> Hi Jean-Christophe,
>
> On Fri, Dec 16, 2016 at 02:32:15PM +0100, Jean-Christophe Trotin wrote:
>> Correct the calculation of the rounding to nearest aligned value in
>> the clamp_align() function. For example, clamp_align(1277, 1, 9600, 2)
>> returns 1276, while it should return 1280.
>
> Why should the function return 1280 instead of 1276, which is closer to
> 1277?
>
>>
>> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-common.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
>> index 57cfe26a..2970ce7 100644
>> --- a/drivers/media/v4l2-core/v4l2-common.c
>> +++ b/drivers/media/v4l2-core/v4l2-common.c
>> @@ -315,7 +315,7 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
>>
>>  	/* Round to nearest aligned value */
>>  	if (align)
>> -		x = (x + (1 << (align - 1))) & mask;
>> +		x = (x + ((1 << align) - 1)) & mask;
>>
>>  	return x;
>>  }
>