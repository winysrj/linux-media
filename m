Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:46485 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZJ0OzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 10:55:21 -0400
Received: by pxi10 with SMTP id 10so159364pxi.33
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 07:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
	 <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
	 <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
Date: Tue, 27 Oct 2009 08:55:25 -0600
Message-ID: <8d0bb7650910270755v38f37f6fh3937e9727493854c@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: dan <danwalkeriv@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Another Sillyname <anothersname@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve,

Thanks for responding.  I created the channels.conf file and ran the
azap command you suggested.  In both cases I get something that looks
like this:

$ azap -r c112
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 723000000 Hz
video pid 0x0120, audio pid 0x0121
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0172 | snr 0172 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |

Does that mean the signal is going in and out?  Any suggestions?

Thanks again.  I really appreciate the work you've done on the driver
for this card, and that you're willing to take the time to help out.

Thanks to Mr. Sillyname, also, for adding another data point.

--dan

On Tue, Oct 27, 2009 at 8:17 AM, Steven Toth <stoth@kernellabs.com> wrote:
>>> I have done some searching online, and that's what led me to scan,
>>> dvbscan and scte65scan, but none of the suggestions I've found so far
>>> seem to help.  Does anyone have any suggestions as to where I can go
>>> from here?  Could there be something wrong with the card itself?  Are
>>> there any diagnostics I could run?
>>>
>>> Thanks in advance for any help that anyone can offer.
>
> Dan,
>
> I'm not aware of any digital cable issues currently.
>
> 1) Do you have any other tvtuners that can validate your signal is
> working correctly? Specifically, for a number of identifiable
> frequencies?
>
> 2) Is your cable plant standard cable, IRC, or HRC?
>
> 3) I suggest you put together a rudamentary $HOME/.azap/channels.conf
> and experiment with azap, that works really well for me.
>
> Here's a sample from my development channels.conf:
> c112:723000000:QAM_256:288:289:713
> c86:597000000:QAM_256:288:289:713
>
> Try this with azap -r c86 or c112, what happens?
>
> - Steve
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
