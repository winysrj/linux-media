Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KWCwU-000576-Qm
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 18:23:24 +0200
Received: by rv-out-0506.google.com with SMTP id b25so30796rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 09:23:18 -0700 (PDT)
Message-ID: <d9def9db0808210923r264b05c3scf204c818ff1195b@mail.gmail.com>
Date: Thu, 21 Aug 2008 18:23:18 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20080821155412.114260@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080821124658.549ced6c@ask-gnewsense>
	<d9def9db0808210507pa76088cx28a955b1840e2147@mail.gmail.com>
	<20080821154705.0ab3f854@ask-gnewsense>
	<d9def9db0808210756y277f21a3wd6fe16f0bc52f9ad@mail.gmail.com>
	<d9def9db0808210800g6cc8c106jb609009c5d44699f@mail.gmail.com>
	<20080821155412.114260@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T USB Device which doesn't require non-free
	software
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

On Thu, Aug 21, 2008 at 5:54 PM, Hans Werner <HWerner4@gmx.de> wrote:
>
> -------- Original-Nachricht --------
>> Datum: Thu, 21 Aug 2008 17:00:06 +0200
>> Von: "Markus Rechberger" <mrechberger@gmail.com>
>> An: "Alex Speed Kjeldsen" <alex.kjeldsen@gmail.com>
>> CC: linux-dvb@linuxtv.org
>> Betreff: Re: [linux-dvb] DVB-T USB Device which doesn\'t require non-free     software
>
>> On Thu, Aug 21, 2008 at 4:56 PM, Markus Rechberger
>> <mrechberger@gmail.com> wrote:
>> > On Thu, Aug 21, 2008 at 3:47 PM, Alex Speed Kjeldsen
>> > <alex.kjeldsen@gmail.com> wrote:
>> >> Just to clarify I have two questions:
>> >>
>> >> 1) If I understand you correctly the Terratec Hybrid XS FM should work
>> without any non-free drivers and firmware. Is this the case?
>> >>
>>
>> the firmware is included in the available driver (so you won't have to
>> bother about where to find the firmware or where to parse it from).
>> The device itself also additionally to the tuner has a small firmware
>> for the Empia chip.
>
> Markus I suspect what you are suggesting is not what Alex is looking for.
>
> Alex is concerned about which licenses these drivers and firmwares are released
> under. He is using gNewSense so he clearly cares that they are free as in free beer *and* free
> as in free speech.


beer costs 2-6$ when going out.

> You say there are two pieces of firmware. Could you clarify (1) which
> files you are talking about, (2) who holds the copyrights and (3) whether the driver
> and firmware source codes are available and under what licenses.
>
> Binaries coded in ascii are still binaries.
>

oh didn't notice that it's a fundamentalistic question, best is to
grab some old hardware and take care that no eeprom is on the device
which might store the same as what is stored in the driver nowadays.
Many chips have internal firmware nowadays, might be hard to pick
something which is purely build in hardware without any blobs :-)
(I won't continue such a discussion).

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
