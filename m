Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:27491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZDBOxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 10:53:52 -0400
Received: by rv-out-0506.google.com with SMTP id g37so2808794rvb.5
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 07:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D4CC16.1010309@linuxtv.org>
References: <15ed362e0904020309k4b286690u6d4d421e321cd91e@mail.gmail.com>
	 <49D4CC16.1010309@linuxtv.org>
Date: Thu, 2 Apr 2009 22:53:50 +0800
Message-ID: <15ed362e0904020753pbc3b739qbccba774f1ef1592@mail.gmail.com>
Subject: Re: API for China DTV standard
From: David Wong <davidtlwong@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 2, 2009 at 10:30 PM, Steven Toth <stoth@linuxtv.org> wrote:
> David Wong wrote:
>>
>> I would like to initiate a discussion of v4l-dvb API proposal for China
>> DTV.
>>
>> Some of you may heard about China DTV standard as DMB-T/H, it is not
>> totally correctly.
>> China standard GB20600-2006 is indeed a union of DMB-TH(multi-carrier)
>> and ADTB-T(single carrier).
>>
>> For API inclusion, I just read the standard document for GB20600. I am
>> not very good in that electronics area,
>> but I gather the following information of parameters, hope I don't
>> miss anything:
>>
>> Number of Carriers:  C=1, C=3780
>> Constellations: 4QAM, 4QAM-NR, 16QAM, 32QAM, 64QAM
>> FEC(LDPC): rate = 0.4,  rate = 0.6, rate = 0.8
>> Frame body size: always 3780 symbols
>> Frame header size:  420 symbols (1/10 guard interval), 595 symbols
>> (0.136 guard interval), 945 symbols (1/5 guard interval)
>> Time domain symbol interleave: M=240(B=52), M=720(B=52)
>>
>> Despite "C=1" and "interleave", I don't know if DVB has such
>> interleave, I see a chance to extend the current FE_OFDM structure (in
>> dvb_frontend_parameters).
>> Or should we create a new structure, like the separation of FE_ATSC
>> and FE_OFDM?
>
> No new structures are required. The existing user facing structures are
> fine.
>
> The S2API will need new properties/types for Constellations, frame header
> size symbol interleave etc.
>
> I suggest:
>
> 1) Identify new #defines EG. M_240_52, M_720_52
> 2) Identify new property types EG. GET/SET_FRAME_BODY_SIZE
> 3) Update the dvb-core property_cache so dvb-core has a place to store these
> values.
> 4) Update dvb-core so that it can interpret you GET/SET_FRAME_BOSY_SIZE and
> other messages.
>
> No user API changes required.
>
> - Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You means because union DVB-T and GB20600, there's a need to get/set
frame body size?

Frame body is always 3780 symbols in GB20600, only frame header is changeable.
Frame header , A.K.A guard interval, is filled with Pseudo-random Number(PN).
So there are three defined frame header modes:
  PN420, 420 symbols, 420 / (420 + 3780) = 1/10 guard interval
  PN595, 595 symbols, 595 / (595 + 3780) = 0.136 guard interval
  PN945, 945 symbols, 945 / (945 + 3780) = 1/5 guard interval

Also, new TRANSMISSION_MODE (C=1 and C=3780) need to be added besides
2K and 8K mode.

Cheers,
David
