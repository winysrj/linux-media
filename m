Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:51943 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0AYKiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 05:38:51 -0500
Received: by fxm7 with SMTP id 7so1864566fxm.28
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 02:38:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20100124T225424-639@post.gmane.org>
References: <4B5CA8F8.3000301@crans.ens-cachan.fr>
	 <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com>
	 <4B5CBF14.1000005@crans.ens-cachan.fr>
	 <loom.20100124T225424-639@post.gmane.org>
Date: Mon, 25 Jan 2010 14:38:49 +0400
Message-ID: <1a297b361001250238j6273e47fh796df0cf5ae5b4b5@mail.gmail.com>
Subject: Re: problem with libdvben50221 and powercam pro V4 [almost solved]
From: Manu Abraham <abraham.manu@gmail.com>
To: pierre gronlier <ticapix@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Pierre,


On Mon, Jan 25, 2010 at 2:03 AM, pierre gronlier <ticapix@gmail.com> wrote:
> DUBOST Brice <dubost <at> crans.ens-cachan.fr> writes:
>>
>> Manu Abraham a écrit :
>> > Hi Brice,
>> >
>> > On Mon, Jan 25, 2010 at 12:09 AM, DUBOST Brice
>> > <dubost <at> crans.ens-cachan.fr> wrote:
>> >> Hello
>> >>
>> >> Powercam just made a new version of their cam, the version 4
>> >>
>> >> Unfortunately this CAM doesn't work with gnutv and applications based on
>> >> libdvben50221
>> >>
>> >> This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
>> >> by stack:-3) after showing the supported ressource id.
>> >>
>> >> The problem is that this camreturns two times the list of supported ids
>> >> (as shown in the log) this behavior make the llci_lookup_callback
>> >> (en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
>> >> at the second call because there is already a session number (in the
>> >> test app the session number is not tested)
>> >>
>> >> I solved the problem commenting out the test for the session number as
>> >> showed in the joined patch (against the latest dvb-apps, cloned today)
>> >
>> > Very strange that, it responds twice on the same session.
>> > Btw, What DVB driver are you using ? budget_ci or budget_av ?
>>
>> Hello
>>
>> The card is a "DVB: registering new adapter (TT-Budget S2-3200 PCI)" and
>> the driver used is budget_ci
>>
>> Do you want me to run some more tests ?
>>
>
> Hello Manu, Hello Brice,
>
> I will run some tests with a TT3200 card too and a Netup card tomorrow.
>
> Regarding the cam returning two times the list of valid cam ids, wouldn't be
> better if the manufacturer corrects it in the cam firmware ?
> What says the en50221 norm about it ?


EN50221 says:

The host sends a CA Info Enquiry object to the application, which
responds by returning an CA Info object with the
appropriate information. The session is then kept open for periodic
operation of the protocol associated with
the CA PMT and CA PMT Reply objects

The specification is not very clear either way, I will try to get some
more understanding in there ..


Regards,
Manu
