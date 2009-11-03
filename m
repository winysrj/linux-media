Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34679 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbZKCCBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 21:01:18 -0500
Received: by bwz27 with SMTP id 27so7043010bwz.21
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 18:01:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <hcnsfa$v70$1@ger.gmane.org>
References: <hcnd9s$c1f$1@ger.gmane.org> <20091102231735.63fd30c4@bk.ru>
	 <hcnsfa$v70$1@ger.gmane.org>
Date: Tue, 3 Nov 2009 02:01:21 +0000
Message-ID: <a413d4880911021801t54d4eca8ra425c0957d8a6eb7@mail.gmail.com>
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
	Nova-HD-S2
From: Another Sillyname <anothersname@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/3 TD <topper.doggle@googlemail.com>:
> On 2009-11-02, Goga777 <goga777@bk.ru> wrote:
>> ðÒÉ×ÅÔÓÔ×ÕÀ, TD
>>
>> you have to use scan-s2
>> http://mercurial.intuxication.org/hg/scan-s2
>
> Hi, and thanks for your quick reply.
>
> I tried it but no better:
> <snip>
> initial transponder DVB-S š12692000 V 19532000 1/2 AUTO AUTO
> initial transponder DVB-S2 12692000 V 19532000 1/2 AUTO AUTO
> ----------------------------------> Using DVB-S
>>>> tune to: 11720:hC34S0:S0.0W:29500:
> DVB-S IF freq is 1120000
> WARNING: >>> tuning failed!!!
>>>> tune to: 11720:hC34S0:S0.0W:29500: (tuning failed)
>
> and the channels.conf was no better than before - it didn't include *one* BBC
> channel, for example.
>
>>
>> or
>>
>> dvb2010 scan
>> http://hg.kewl.org/dvb2010/
>
> Once I got it working, same:
> Astra 2A/2B/2D/Eurobird 1 (28.2E) 10714 H DVB-S QPSK 22000 5/6 ONID:0 TID:0
> AGC:0% SNR:0%
> š šCan't tune
>
> Astra 2A/2B/2D/Eurobird 1 (28.2E) 10729 V DVB-S QPSK 22000 5/6 ONID:0 TID:0
> AGC:0% SNR:0%
> š šCan't tune
>
> Where do I go from here?
> --
> TD
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Are you running myth .21 or .22?
