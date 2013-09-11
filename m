Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54134 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3IKO5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 10:57:49 -0400
Received: by mail-vc0-f182.google.com with SMTP id hf12so6428836vcb.27
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 07:57:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9Kdmzj3uTP=n7nqBgZdH6MtUPeg1bBWA3=SLmC+-9NCfw@mail.gmail.com>
References: <CALuNSF4znGu+NdsZs3eb0A5vqgyHNC13f8qXunNE2tXVxC=UTg@mail.gmail.com>
 <CAHFNz9Kdmzj3uTP=n7nqBgZdH6MtUPeg1bBWA3=SLmC+-9NCfw@mail.gmail.com>
From: Simon Liddicott <simon@liddicott.com>
Date: Wed, 11 Sep 2013 15:57:28 +0100
Message-ID: <CALuNSF4AkDKucyY_3OfvMy4iz=NxFeH8OjwsT32-M_cBfm8-rA@mail.gmail.com>
Subject: Re: Correct scan file format?
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Manu.

Before I prepare to patch the entire UK scan files can someone confirm
that the below is acceptable:

#----------------------------------------------------------------------------------------------
# Auto-generated from:
# <http://stakeholders.ofcom.org.uk/broadcasting/guidance/tech-guidance/transmitter-frequency/>
#----------------------------------------------------------------------------------------------
# location and provider: UK, Sutton Coldfield
# date (yyyy-mm-dd)    : 2013-09-11
#
# T[2] <freq>     <bw>  <fec_hi> <fec_lo> <mod>   <tm> <guard> <hi>
[<plp_id>] [# comment]
#----------------------------------------------------------------------------------------------
T       650000000  8MHz  2/3      NONE     QAM64   8k   1/32    NONE
         # PSB1
T       674000000  8MHz  2/3      NONE     QAM64   8k   1/32    NONE
         # PSB2
T2      626167000  8MHz  2/3      NONE     QAM256  32k  1/128   NONE
0         # PSB3
T       642000000  8MHz  3/4      NONE     QAM64   8k   1/32    NONE
         # COM4
T       666000000  8MHz  3/4      NONE     QAM64   8k   1/32    NONE
         # COM5
T       618167000  8MHz  3/4      NONE     QAM64   8k   1/32    NONE
         # COM6

Si.

On 11 September 2013 14:30, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Wed, Sep 11, 2013 at 6:19 PM, Simon Liddicott <simon@liddicott.com> wrote:
>> What form should T2 multiplexes take in the DVB scan files?
>>
>> In the uk-CrystalPalace scan file
>> <http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-t/uk-CrystalPalace>
>> the PLP_ID and System_ID are included before the frequency but in
>> ro-Krasnador scan file
>> <http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-t/ru-Krasnodar>
>> the PLP_ID is included at the end of the line and it has no System_ID.
>
>
>
> PLP_ID should be the very last entity to preserve compatibility.
>
>
>
>> I don't have a T2 tuner to test. Is a PLP_ID required in the scan file
>> as in the UK we only have one?
>>
>
>
>
> If you have only a single stream, it wouldn't make any difference if you
> have a PLP_ID or not.
>
>
>
>> I presume the System_ID has been included in the Crystal Palace file
>> because it was known by w_scan, but is it required for T2?
>>
>
>
> System ID is used for decryption with Conditional Access. If you don't
> need to use a CA module, then you can ignore it.
>
>
> Regards,
>
> Manu
