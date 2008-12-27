Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LGPXW-0003ip-1b
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 04:08:35 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1844550qwb.17
	for <linux-dvb@linuxtv.org>; Fri, 26 Dec 2008 19:08:29 -0800 (PST)
Message-ID: <412bdbff0812261908l262ef8f1h8362910a88e846f6@mail.gmail.com>
Date: Fri, 26 Dec 2008 22:08:29 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1230333055.3125.6.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0812261348h35b28437m5c87f43a3e6a5e33@mail.gmail.com>
	<1230333055.3125.6.camel@palomino.walls.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] mxl5005s tuner analog support
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

On Fri, Dec 26, 2008 at 6:10 PM, Andy Walls <awalls@radix.net> wrote:
> On Fri, 2008-12-26 at 16:48 -0500, Devin Heitmueller wrote:
>> Hello,
>>
>> I working on the analog support for the Pinnacle Ultimate 880e
>> support, and that device includes an mxl5005s tuner.
>>
>> I went to do the normal changes to em28xx to support another tuner,
>> which prompted me to wonder:
>>
>> Is the analog support known to to work in Linux for this tuner for any
>> other device?
>>
>> The reason I ask is because I hit an oops and when I looked at the
>> source I found some suspicious things:
>>
>> * No entry in tuner.h
>> * No attach command in tuner-core.c
>> * No definition of set_analog_params() callback in mxl5005s.c
>
> The mxl5005s support was added to the v4l-dvb repo by Steven Toth for
> the HVR-1600 which uses it exclusively for ATSC (QAM and 8-VSB).
>
> The source of Steve's driver is from RealTek.  More comments on origin
> can be found in the mxl5005s.[ch] files.
>
> There is some history in the list archives between Steve and Manu (and
> me indirectly) on the use of the mxl500x source module.
>
>
>> I wonder if perhaps the driver was ported from some other source and
>> nobody ever got around to getting the analog support working?  If
>> that's the case then that is fine (I'll make it work), but I want to
>> know if I am just missing something obvious here....
>
> I'd like to get the driver working a little better myself.  Steve said
> the QAM suffers a 3 dB hit compared to Manu's version (IIRC).  I'd like
> a decent signal strength readout.   If I had a data sheet from MaxLinear
> maybe I could do something.  It still looks like details of external
> tracking filter hardware need to be known and tested for each particular
> board though.
>
> Regards,
> Andy

Thanks for the feedback.  I just wanted a sanity check that I wasn't
missing something obvious.  I'll take a look at the code, as well as
the original RealTek code and see if I can get the analog side
working.

I'll send some emails and see if I can get the datasheet - I didn't
ask for it when I started the work since I was under the impression
that the driver was mature.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
