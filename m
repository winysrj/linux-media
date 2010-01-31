Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.211.179]:41429 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0AaRnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 12:43:41 -0500
Received: by ywh9 with SMTP id 9so3724438ywh.19
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 09:43:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264955483.28401.32.camel@alkaloid.netup.ru>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
	 <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
	 <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
	 <1264951975.28401.8.camel@alkaloid.netup.ru>
	 <b36f333c1001310825n6ae6e5dbg45a0cf135d2e89e@mail.gmail.com>
	 <1264955483.28401.32.camel@alkaloid.netup.ru>
Date: Sun, 31 Jan 2010 18:43:40 +0100
Message-ID: <b36f333c1001310943t3f655b03w2fe75a63b3e952a7@mail.gmail.com>
Subject: Re: CAM appears to introduce packet loss
From: Marc Schmitt <marc.schmitt@gmail.com>
To: Abylai Ospan <aospan@netup.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 31, 2010 at 5:31 PM, Abylai Ospan <aospan@netup.ru> wrote:
> On Sun, 2010-01-31 at 17:25 +0100, Marc Schmitt wrote:
>> Compiling from source made me stumble across
>> http://www.mail-archive.com/ubuntu-devel-discuss@lists.ubuntu.com/msg09422.html
>> I just left out the firedtv driver as recommended.
>>
>> I'm getting the following kernel output after enabling dvb_demux_speedcheck:
>> [  330.366115] TS speed 40350 Kbits/sec
>> [  332.197693] TS speed 40085 Kbits/sec
>> [  334.011856] TS speed 40528 Kbits/sec
>> [  335.843466] TS speed 40107 Kbits/sec
>> [  337.665411] TS speed 40261 Kbits/sec
>> [  339.496959] TS speed 40107 Kbits/sec
>> [  341.318289] TS speed 40350 Kbits/sec
>>
>> Do you think the CI/CAM can not handle that?
> 40 Mbit/sec is high bitrate for some CAM's.
>
> You can:
> 1. Try to contact with CAM vendor and check maximum bitrate which can be
> passed throught this CAM

I tried that CAM in a TV with DVB-C support. The image was perfect so
I suspect that the CAM itself can handle it unless the TV did HW PID
filtering before sending the stream to the CAM, as you point out
below... Is that to be expected?

> 2. Try to find reception card with hardware PID filtering and pass only
> interesting PID's throught CAM. Bitrate should be equal to bitrate of
> one channel - aprox. 4-5 mbit/sec ( not 40 mbit/sec).

Do you have a recommendation for such a card?
Would it be possible to do the filtering in software somehow?

> 3.may be some fixes can be made on TS output from demod. Demod's usually
> has tunable TS output timings/forms. You should check TS clock by
> oscilloscope and then try to change TS timings/forms in demod.

Unfortunately, I don't have the necessary equipment/knowledge to do this. :(
I'd assume the DVB provider could give me the TS clock? But then I'm
at bit at a loss with "change TS timings/forms in demod". What exactly
are you referring to by "demod".

Thanks,
    Marc
