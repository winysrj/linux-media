Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49861 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752856AbZCXSXV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 14:23:21 -0400
Message-ID: <49C92514.8050307@gmx.de>
Date: Tue, 24 Mar 2009 19:23:16 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [question] atsc and api v5
References: <49C90BCC.1080401@gmx.de> <412bdbff0903241013r479fbaabo8d7f45a7153aebb9@mail.gmail.com>
In-Reply-To: <412bdbff0903241013r479fbaabo8d7f45a7153aebb9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Mar 24, 2009 at 12:35 PM, wk <handygewinnspiel@gmx.de> wrote:
>   
>> While trying to update an application to API v5 some question arised.
>>
>> Which type of "delivery_system" should be set for ATSC?
>> <frontend.h> says...
>>
>> SYS_DVBC_ANNEX_AC,   <- european DVB-C
>> SYS_DVBC_ANNEX_B,      <- american ATSC QAM
>> ..
>> SYS_ATSC,   <- oops, here we have ATSC again, cable and terrestrial not
>> named? Is this VSB *only*?
>>
>>
>>
>> Which one should i choose, "SYS_ATSC" for both (VSB and QAM),
>> or should i choose SYS_DVBC_ANNEX_B for ATSC cable and SYS_ATSC for VSB?
>>
>> thanks,
>> Winfried
>>     
>
> I'm pretty sure it's SYS_ATSC for both VSB and QAM.
>
> Devin
>
>
>   
Meanwhile i think this is the answer..

dvb-core/dvb_frontend.c line 1076

/* Synchronise the legacy tuning parameters into the cache, so that 
demodulator
 * drivers can use a single set_frontend tuning function, regardless of 
whether
 * it's being used for the legacy or new API, reducing code and complexity.
 */
static void dtv_property_cache_sync(struct dvb_frontend *fe,
                    struct dvb_frontend_parameters *p)
{
.....
    switch (fe->ops.info.type) {
......
    case FE_ATSC:
        c->modulation = p->u.vsb.modulation;
        if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
            c->delivery_system = SYS_ATSC;
        else
            c->delivery_system = SYS_DVBC_ANNEX_B;          <- QAM_64 
and QAM_256 here
        break;


That means the naming is completely misleading here.
I have to choose SYS_DVBC_ANNEX_B for ATSC QAM, but ATSC VSB needs SYS_ATSC.

Winfried


