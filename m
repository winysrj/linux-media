Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62254 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZL0WX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 17:23:26 -0500
Received: by fxm25 with SMTP id 25so4256779fxm.21
        for <linux-media@vger.kernel.org>; Sun, 27 Dec 2009 14:23:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261673477.2119.1.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de> <1261578615.8948.4.camel@slash.doma>
	 <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
	 <1261611901.8948.37.camel@slash.doma> <4B339A8F.8020201@freenet.de>
	 <1261673477.2119.1.camel@slash.doma>
Date: Mon, 28 Dec 2009 02:23:25 +0400
Message-ID: <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
From: Manu Abraham <abraham.manu@gmail.com>
To: =?UTF-8?Q?Alja=C5=BE_Prusnik?= <prusnik@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-13
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Aljaz,

On Thu, Dec 24, 2009 at 8:51 PM, Aljaþ Prusnik <prusnik@gmail.com> wrote:
> On èet, 2009-12-24 at 17:45 +0100, Ruediger Dohmhardt wrote:
>> Aljaþ, thanks for the "reply". As Manu said above there was a build problem.
>> As said already in this Thread, I downloaded version 2315248f648c, which
>> compiles fine and
>> has all modules for the 2033 DVB-C.
>
> I have the same version and it doesn't work for me. I have a 2040
> module.

Can you please do a lspci -vn for the Mantis card you have ? Also try
loading the mantis.ko module with verbose=5 module parameter, to get
more debug information.

Regards,
Manu
