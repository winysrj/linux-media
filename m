Return-path: <mchehab@gaivota>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:55552 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab0LPLPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 06:15:17 -0500
Received: by ewy10 with SMTP id 10so1842633ewy.4
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 03:15:15 -0800 (PST)
Message-ID: <4D09F487.4010906@mvista.com>
Date: Thu, 16 Dec 2010 14:14:15 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v6 5/7] davinci vpbe: platform specific additions
References: <1292404268-12517-1-git-send-email-manjunath.hadli@ti.com>	<4D08A475.6080703@mvista.com> <A69FA2915331DC488A831521EAE36FE401BE4AC794@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401BE4AC794@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

On 15-12-2010 18:54, Karicheri, Muralidharan wrote:

>> I think the DM644x EVM board changes should be in a separate patch.

> Any reason?

    The resaon is simple: you shouldn't mix SoC-level and board-level changes.

> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874

WBR, Sergei
