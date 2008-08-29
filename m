Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 29 Aug 2008 12:03:02 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>
To: Hans Werner <HWerner4@gmx.de>
Message-id: <48B81DB6.9030206@linuxtv.org>
MIME-version: 1.0
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
	<48B78AE6.1060205@gmx.net> <48B7A60C.4050600@kipdola.com>
	<48B802D8.7010806@linuxtv.org> <20080829154342.74800@gmx.net>
	<37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>,
	skerit@kipdola.com
Subject: Re: [linux-dvb] [PATCH] Future of DVB-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Michael Krufky wrote:
> On Fri, Aug 29, 2008 at 11:43 AM, Hans Werner <HWerner4@gmx.de> wrote:
>>> ... and yes, many people understand you.
>> :) Thanks to everyone who replied so far. I am glad people care about this.
>>
>>>> We know all about the "coding in your free time" and we can only have
>>>> the highest respect for that, but the drivers are completely abandonded,
>>>> and that's how we feel, too.
>>> No, and that's my HVR4000 code you're talking about (and the good work
>>> of Darron Broad, which was then picked up by Igor). The driver is
>>> marginalized, it's not abandoned.
>> I hope your and Darron's drivers (http://dev.kewl.org/hauppauge) are not seen as
>> marginalized. The multifrontend (MFE) patch by you and Darron is the driver that I
>> actually *use* for watching TV. It works nicely with Kaffeine without modification. And I,
>> for one, appreciate your sane approach and the simplicity of the techniques you used to
>> add DVB-S2 support (using sysctls for the SFE driver, and wrapping two ioctls to pull in
>> extra parameters for the MFE driver). If the kernel API is changed sensibly it should be
>> easy and quick to adapt your drivers to fit in.
>>
>>> The HVR4000 situation is under review, the wheels are slowly turning....
>> If you are able to say anything about that I would be very interested.
>>
>> Now, to show how simple I think all this could be, here is a PATCH implementing what
>> I think is the *minimal* API required to support DVB-S2.
>>
>> Notes:
>>
>> * same API structure, I just added some new enums and variables, nothing removed
>> * no changes required to any existing drivers (v4l-dvb still compiles)
>> * no changes required to existing applications (just need to be recompiled)
>> * no drivers, but I think the HVR4000 MFE patch could be easily adapted
>>
>> I added the fe_caps2 enum because we're running out of bits in the capabilities bitfield.
>> More elegant would be to have separate bitfields for FEC capabilities and modulation
>> capabilities but that would require (easy) changes to (a lot of) drivers and applications.
>>
>> Why should we not merge something simple like this immediately? This could have been done
>> years ago. If it takes several rounds of API upgrades to reach all the feature people want then
>> so be it, but a long journey begins with one step.
> 
> This will break binary compatibility with existing apps.  You're right
> -- those apps will work with a recompile, but I believe that as a
> whole, the linux-dvb kernel and userspace developers alike are looking
> to avoid breaking binary compatibility.

Hans, thanks for your kind words.

I've seen patches similar to this from a number of people, but this only 
solves today's problem, it doesn't help with ISDB-T, DVB-H, CMMB, 
ATSC-MH etc.

As mkrufky says, it also breaks compatibility.

... as I say, the wheels are turning so keep watching this mailing list.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
