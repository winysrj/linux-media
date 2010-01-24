Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:44746 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0AXVnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 16:43:51 -0500
Message-ID: <4B5CBF14.1000005@crans.ens-cachan.fr>
Date: Sun, 24 Jan 2010 22:43:48 +0100
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: problem with libdvben50221 and powercam pro V4 [almost solved]
References: <4B5CA8F8.3000301@crans.ens-cachan.fr> <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com>
In-Reply-To: <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham a écrit :
> Hi Brice,
> 
> On Mon, Jan 25, 2010 at 12:09 AM, DUBOST Brice
> <dubost@crans.ens-cachan.fr> wrote:
>> Hello
>>
>> Powercam just made a new version of their cam, the version 4
>>
>> Unfortunately this CAM doesn't work with gnutv and applications based on
>> libdvben50221
>>
>> This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
>> by stack:-3) after showing the supported ressource id.
>>
>>
>> I found out that this cam works with the test application of the
>> libdvben50221
>>
>> The problem is that this camreturns two times the list of supported ids
>> (as shown in the log) this behavior make the llci_lookup_callback
>> (en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
>> at the second call because there is already a session number (in the
>> test app the session number is not tested)
>>
>> I solved the problem commenting out the test for the session number as
>> showed in the joined patch (against the latest dvb-apps, cloned today)
>>
>> Since I'm not an expert of the libdvben50221, I'm asking the list if
>> there is better way to solve this problem and improve my patch so it can
>> be integrated upstream.
> 
> 
> 
> Very strange that, it responds twice on the same session.
> Btw, What DVB driver are you using ? budget_ci or budget_av ?

Hello

The card is a "DVB: registering new adapter (TT-Budget S2-3200 PCI)" and
the driver used is budget_ci

Do you want me to run some more tests ?

Regards

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
