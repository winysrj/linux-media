Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56903 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0E2Epm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 00:45:42 -0400
Received: by fxm10 with SMTP id 10so1198483fxm.19
        for <linux-media@vger.kernel.org>; Fri, 28 May 2010 21:45:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com>
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com>
Date: Sat, 29 May 2010 07:45:40 +0300
Message-ID: <AANLkTinU8T0fWHHHS0azFK33Ec8yYLguiZxos9z7hOvP@mail.gmail.com>
Subject: Re: What ever happened to standardizing signal level?
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

at least in driver for the frontend found on TBS 6980 Dual DVB-S2 card
i added options "esno" and "dbm" respectively for reporting SNR
(actually C/N) in EsNo dB and signal strength in dBm, which is at
least real statistics about the signal and not like almost meaningless
percents. so, that's one way to go. some DVB-S/S2 demodulators use
EsNo dB and other EbNo dB and so maybe step toward some
standardization is routines for conversion between those two. also,
maybe there will be common agreement how to convert signal strength in
dBm to percents and SNR (C/N) in EsNo or EbNo dB to percents. i
believe that will guarantee more standard way to give information
about the signal, but it's just my opinion.

On Sat, May 29, 2010 at 6:09 AM, VDR User <user.vdr@gmail.com> wrote:
> A lot of people were anticipating this happening but it seems to have
> stalled out.  Does anyone know what the intentions are?  Many users
> were also hoping to _finally_ get a good signal meter for linux as
> well.  If anyone has any info, please share!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
