Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:50916 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZDBOat (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 10:30:49 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHH00CR99NBBBA0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 02 Apr 2009 10:30:47 -0400 (EDT)
Date: Thu, 02 Apr 2009 10:30:46 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: API for China DTV standard
In-reply-to: <15ed362e0904020309k4b286690u6d4d421e321cd91e@mail.gmail.com>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <49D4CC16.1010309@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <15ed362e0904020309k4b286690u6d4d421e321cd91e@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Wong wrote:
> I would like to initiate a discussion of v4l-dvb API proposal for China DTV.
> 
> Some of you may heard about China DTV standard as DMB-T/H, it is not
> totally correctly.
> China standard GB20600-2006 is indeed a union of DMB-TH(multi-carrier)
> and ADTB-T(single carrier).
> 
> For API inclusion, I just read the standard document for GB20600. I am
> not very good in that electronics area,
> but I gather the following information of parameters, hope I don't
> miss anything:
> 
> Number of Carriers:  C=1, C=3780
> Constellations: 4QAM, 4QAM-NR, 16QAM, 32QAM, 64QAM
> FEC(LDPC): rate = 0.4,  rate = 0.6, rate = 0.8
> Frame body size: always 3780 symbols
> Frame header size:  420 symbols (1/10 guard interval), 595 symbols
> (0.136 guard interval), 945 symbols (1/5 guard interval)
> Time domain symbol interleave: M=240(B=52), M=720(B=52)
> 
> Despite "C=1" and "interleave", I don't know if DVB has such
> interleave, I see a chance to extend the current FE_OFDM structure (in
> dvb_frontend_parameters).
> Or should we create a new structure, like the separation of FE_ATSC
> and FE_OFDM?

No new structures are required. The existing user facing structures are fine.

The S2API will need new properties/types for Constellations, frame header size 
symbol interleave etc.

I suggest:

1) Identify new #defines EG. M_240_52, M_720_52
2) Identify new property types EG. GET/SET_FRAME_BODY_SIZE
3) Update the dvb-core property_cache so dvb-core has a place to store these values.
4) Update dvb-core so that it can interpret you GET/SET_FRAME_BOSY_SIZE and 
other messages.

No user API changes required.

- Steve
