Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52173 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3AATN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 14:13:57 -0500
Received: by mail-ob0-f177.google.com with SMTP id uo13so12076844obb.8
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 11:13:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130101152932.3873d4cc@redhat.com>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
	<CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
	<20130101130041.52dee65f@redhat.com>
	<CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
	<20130101152932.3873d4cc@redhat.com>
Date: Wed, 2 Jan 2013 00:38:50 +0530
Message-ID: <CAHFNz9LzBX0G9G0G_6C+WHooaQ1ridG1pkCcOPyzPG+FgOZKxw@mail.gmail.com>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 1, 2013 at 10:59 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Tue, 1 Jan 2013 22:18:49 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>
>> > [RFCv4] dvb: Add DVBv5 properties for quality parameters
>> >
>> > The DVBv3 quality parameters are limited on several ways:
>> >         - Doesn't provide any way to indicate the used measure;
>> >         - Userspace need to guess how to calculate the measure;
>> >         - Only a limited set of stats are supported;
>> >         - Doesn't provide QoS measure for the OFDM TPS/TMCC
>> >           carriers, used to detect the network parameters for
>> >           DVB-T/ISDB-T;
>> >         - Can't be called in a way to require them to be filled
>> >           all at once (atomic reads from the hardware), with may
>> >           cause troubles on interpreting them on userspace;
>> >         - On some OFDM delivery systems, the carriers can be
>> >           independently modulated, having different properties.
>> >           Currently, there's no way to report per-layer stats;
>>
>> per layer stats is a mythical bird, nothing of that sort does exist.
>
> Had you ever read or tried to get stats from an ISDB-T demod? If you
> had, you would see that it only provides per-layer stats. Btw, this is
> a requirement to follow the ARIB and ABNT ISDB specs.

I understand you keep writing junk for ages, but nevertheless:

Do you have any idea what's a BBHEADER (DVB-S2) or
PLHEADER (DVB-T2) ? The headers do indicate what MODCOD
(aka Modulation/Coding Standard follows, whatever mode ACM,
VCM or CCM) follows. These MODCOD foolows a TDM approach
with a hierarchial modulation principle. This is exactly what ISDB
does too.

And for your info:

" The TMCC control information is
common to all TMCC carriers and
error correction is performed by using
difference-set cyclic code."

Manu
