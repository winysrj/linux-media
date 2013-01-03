Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43134 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab3ACPfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 10:35:25 -0500
Message-ID: <50E5A515.4050500@iki.fi>
Date: Thu, 03 Jan 2013 17:34:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com> <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com> <20130101130041.52dee65f@redhat.com> <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
In-Reply-To: <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/01/2013 06:48 PM, Manu Abraham wrote:
> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>
>> [RFCv4] dvb: Add DVBv5 properties for quality parameters
>>
>> The DVBv3 quality parameters are limited on several ways:
>>          - Doesn't provide any way to indicate the used measure;
>>          - Userspace need to guess how to calculate the measure;
>>          - Only a limited set of stats are supported;
>>          - Doesn't provide QoS measure for the OFDM TPS/TMCC
>>            carriers, used to detect the network parameters for
>>            DVB-T/ISDB-T;
>>          - Can't be called in a way to require them to be filled
>>            all at once (atomic reads from the hardware), with may
>>            cause troubles on interpreting them on userspace;
>>          - On some OFDM delivery systems, the carriers can be
>>            independently modulated, having different properties.
>>            Currently, there's no way to report per-layer stats;
>
> per layer stats is a mythical bird, nothing of that sort does exist. If some
> driver states that it is simply due to lack of knowledge at the coding side.
>
> ISDB-T uses hierarchial modulation, just like DVB-S2 or DVB-T2

Manu, you confused now two concept (which are aimed to resolve same real 
life problem) - hierarchical coding and multiple transport stream. Both 
are quite similar on lower level of radio channel, but differs on upper 
levels.

Hierarchical is a little bit weird baby as it remuxes those lower lever 
radio channels (called layers in case of ISDB-T) to one single mux! 
There is only single TS which demodulator is responsible to remux all 
those 3 physical "layer" channels, which could be modulated differently. 
So after demodulation you really has a TS which contains stream that has 
different statistics. That's opposite to compared for multiple TS 
principle used for DVB-T2/S2. In case of multiple TS you have same 
statistics for whole TS (but naturally there could be multiple TS after 
demodulation).

regards
Antti

-- 
http://palosaari.fi/
