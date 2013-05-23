Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:63931 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab3EWJZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 05:25:46 -0400
Received: by mail-vb0-f43.google.com with SMTP id e15so1976467vbg.2
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 02:25:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8v5Msfwr11tpC5xR90e5E02Mz+OJcqnYohmp2ri_VgC1Q@mail.gmail.com>
References: <CAPgLHd_iDfVzq2S_uSh1tBVpQdFa4oyMpWGovDDNCYsh0bLJog@mail.gmail.com>
 <CA+V-a8v5Msfwr11tpC5xR90e5E02Mz+OJcqnYohmp2ri_VgC1Q@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 14:55:25 +0530
Message-ID: <CA+V-a8vTXaDmPuPxFUDxv4+pQc4jbwBafUWu7Y-Hdbbdo+=Xqg@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_display: fix error return code in vpif_probe()
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: mchehab@redhat.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Wei Yongjun <weiyj.lk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 13, 2013 at 11:34 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Wei,
>
> Thanks for the patch.
>
> On Mon, May 13, 2013 at 11:27 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return -ENODEV in the subdevice register error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
Can you pick this patch ? and a similar looking patch for vpif display.

Regards,
--Prabhakar Lad
