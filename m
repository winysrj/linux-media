Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:55325 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0LOPy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 10:54:58 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Date: Wed, 15 Dec 2010 09:54:44 -0600
Subject: RE: [PATCH v6 5/7] davinci vpbe: platform specific additions
Message-ID: <A69FA2915331DC488A831521EAE36FE401BE4AC794@dlee06.ent.ti.com>
References: <1292404268-12517-1-git-send-email-manjunath.hadli@ti.com>
 <4D08A475.6080703@mvista.com>
In-Reply-To: <4D08A475.6080703@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Sergei,

>I think the DM644x EVM board changes should be in a separate patch.

Any reason?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874

>-----Original Message-----
>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>Of Sergei Shtylyov
>Sent: Wednesday, December 15, 2010 6:20 AM
>To: Hadli, Manjunath
>Cc: dlos; Mauro Carvalho Chehab; LMML
>Subject: Re: [PATCH v6 5/7] davinci vpbe: platform specific additions
>
>Hello.
>
>On 15-12-2010 12:11, Manjunath Hadli wrote:
>
>> This patch implements the overall device creation for the Video
>> display driver, and addition of tables for the mode and output list.
>
>> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
>> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
>> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
>[...]
>
>> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-
>davinci/board-dm644x-evm.c
>> index 34c8b41..e9b1243 100644
>> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
>
>    I think the DM644x EVM board changes should be in a separate patch.
>
>WBR, Sergei
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
