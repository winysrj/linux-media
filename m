Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L54XZ-00040S-3B
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 21:29:47 +0100
Received: by nf-out-0910.google.com with SMTP id g13so97235nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 12:29:39 -0800 (PST)
Message-ID: <412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
Date: Tue, 25 Nov 2008 15:29:39 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Robert Watkins" <robert@watkin5.net>
In-Reply-To: <1227644366.6949.18.camel@watkins-desktop>
MIME-Version: 1.0
Content-Disposition: inline
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
	<492A8A43.4060001@rusch.name> <u0lnYVBoGwKJFwJg@onasticksoftware.net>
	<1227556939.16187.0.camel@youkaida>
	<100c0ba70811241329s594e3112h467e1deff9d3c1ac@mail.gmail.com>
	<1227644366.6949.18.camel@watkins-desktop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
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

On Tue, Nov 25, 2008 at 3:19 PM, Robert Watkins <robert@watkin5.net> wrote:
> On Mon, 2008-11-24 at 21:29 +0000, Richard Palmer wrote:
>> Hi,
>>
>> On Mon, Nov 24, 2008 at 8:02 PM, Nicolas Will <nico@youplala.net> wrote:
>> > On Mon, 2008-11-24 at 19:34 +0000, jon bird wrote:
>> >> could be although on perusing the mailing list archives this seemed
>> >> to
>> >> be a recurring problem of which various attempts have been made to
>> >> investigate/fix but there didn't seem to be a conclusion to it all.
>> >> Hence I just thought I'd see what the latest state of play was and
>> >> report back anything potentially useful.....
>> >
>> > Well, this has normally been solved. Your report is the first one in a
>> > long time.
>>
>> I'll second the report. Also with a VIA motherboard, so the USB ports
>> could be the
>> culprit. Running Mythbuntu with kernel 2.6.24 and using the new
>> firmware still gives
>> i2c errors.
>>
>
> I've found Unbuntu 2.6.24-21-386 worked reasonable well with errors
> requiring a shut down and cold start once or twice a week.
>
> After an upgrade, I found 2.6.27-7-generic fails within seconds of
> starting to record on two tuners.
>  dvb-usb: error while enabling fifo.
>
> The current v4l-dvb drivers have the same issue.
>
> I also occasionally get
>  dib0700: firmware download failed at 17248 with -110
>
> My PC's got ATI's IXP SB400 USB2 Host Controllers.
>
> Rob Watkins

Hello Robert,

Are you running dib0700 firmware version 1.10 or 1.20?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
