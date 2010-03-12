Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59375 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236Ab0CLUkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 15:40:52 -0500
Received: by fxm19 with SMTP id 19so1587245fxm.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 12:40:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f509f3091003120927n4feca4d4h6616524adf0d36ee@mail.gmail.com>
References: <f509f3091001311223q19a9854fwb546e6fcadc08021@mail.gmail.com>
	 <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
	 <f509f3091003120927n4feca4d4h6616524adf0d36ee@mail.gmail.com>
Date: Sat, 13 Mar 2010 00:40:49 +0400
Message-ID: <1a297b361003121240q39129f5fhb9450c691b79d52b@mail.gmail.com>
Subject: Re: [linux-dvb] Twinhan dtv 3030 mantis
From: Manu Abraham <abraham.manu@gmail.com>
To: Niklas Claesson <nicke.claesson@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 9:27 PM, Niklas Claesson
<nicke.claesson@gmail.com> wrote:
> I saw that there has been som recent development on the
> mantis-v4l-dvb-tree. Unfortunately it still doesn't work for my 3030.
> Is there anyway I can help? Is it normal that the IRQ 23 is used with
> more then one card?

That shouldn't be a problem. A shared handler is requested.

> Mar 12 18:19:03 niklas-desktop kernel: [  254.410969] Mantis
> 0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> Mar 12 18:19:03 niklas-desktop kernel: [  254.411971] DVB: registering
> new adapter (Mantis DVB adapter)
> Mar 12 18:19:04 niklas-desktop kernel: [  255.084297] Mantis: probe of
> 0000:05:02.0 failed with error -1


Can you please load the mantis driver with module option verbose=5 and
post the details ?

Regards,
Manu
