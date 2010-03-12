Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63498 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab0CLR1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 12:27:34 -0500
Received: by bwz1 with SMTP id 1so1248233bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 09:27:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
References: <f509f3091001311223q19a9854fwb546e6fcadc08021@mail.gmail.com>
	 <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
Date: Fri, 12 Mar 2010 18:27:32 +0100
Message-ID: <f509f3091003120927n4feca4d4h6616524adf0d36ee@mail.gmail.com>
Subject: Re: [linux-dvb] Twinhan dtv 3030 mantis
From: Niklas Claesson <nicke.claesson@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I saw that there has been som recent development on the
mantis-v4l-dvb-tree. Unfortunately it still doesn't work for my 3030.
Is there anyway I can help? Is it normal that the IRQ 23 is used with
more then one card?

Mar 12 18:19:03 niklas-desktop kernel: [  254.410969] Mantis
0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Mar 12 18:19:03 niklas-desktop kernel: [  254.411971] DVB: registering
new adapter (Mantis DVB adapter)
Mar 12 18:19:04 niklas-desktop kernel: [  255.084297] Mantis: probe of
0000:05:02.0 failed with error -1

Regards,
Niklas Claesson


2010/2/11 Manu Abraham <abraham.manu@gmail.com>
>
> Can you please try again ?
>
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
