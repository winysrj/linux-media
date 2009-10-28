Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:63487 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbZJ1Foh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 01:44:37 -0400
Received: by pzk26 with SMTP id 26so359328pzk.4
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 22:44:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83bcf6340910270920i4323faf8mb5b482b75bda7291@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
	 <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
	 <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
	 <8d0bb7650910270755v38f37f6fh3937e9727493854c@mail.gmail.com>
	 <83bcf6340910270920i4323faf8mb5b482b75bda7291@mail.gmail.com>
Date: Tue, 27 Oct 2009 23:44:41 -0600
Message-ID: <8d0bb7650910272244wfdbdda0kae6bec6cd94e2bcc@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: dan <danwalkeriv@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Another Sillyname <anothersname@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I do have 2 2-way splitters between the card in the wall.  I tried
hooking the card straight to the cable outlet on the wall and ran some
more tests.  It's a little difficult, because there's only one cable
outlet in my whole apartment, and it means doing some re-arranging and
being offline while I'm running the tests.

I'm not sure if there was any change.  Here's the output from azap for
a few channels.  I added one in the 40 range, like you asked, and I
also added another frequency that my TV is able tune, 717000000.

$ azap -r c112
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 723000000 Hz
video pid 0x0120, audio pid 0x0121
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0110 | snr 0113 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0110 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0110 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |

$ azap -r c45
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 417000000 Hz
video pid 0x0120, audio pid 0x0121
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0121 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |

$ azap -r c111
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 717000000 Hz
video pid 0x0120, audio pid 0x0121
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0144 | snr 0148 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0144 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0144 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0144 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0144 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0144 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0148 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 07 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 |

Just in case it's helpful, my TV gives this information about the
channel on that last frequency when connected to the television with
the same cable in the same configuration:
Physical Channel: 111
Frequency: 71700000
SNR: 39
Signal: 100

I tried scanning with scan again, with the card plugged straight into
the wall with this command:

$ scan -f /dev/dvb/adapter0/frontend0 -5
/usr/share/dvb/atsc/us-Cable-Standard-center-frequencies-QAM256  >
scan_channels_standard.conf


The 717000000 frequency that tunes fine on my TV gave the following output:
>>> tune to: 717000000:QAM_256
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb

The scan program still doesn't find any channels.

I also tried testing the other adapter, like you suggested, but I get
this error:
$ azap -a1 -r c111
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
ERROR: failed opening '/dev/dvb/adapter1/frontend0' (Device or resource busy)

lsof doesn't show anything as using it, so I'm not sure what's going on.

I'm sorry if that's an overload of information.  Thanks again for the help.

--dan

On Tue, Oct 27, 2009 at 10:20 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On Tue, Oct 27, 2009 at 10:55 AM, dan <danwalkeriv@gmail.com> wrote:
>> Steve,
>>
>> Thanks for responding.  I created the channels.conf file and ran the
>> azap command you suggested.  In both cases I get something that looks
>> like this:
>>
>> $ azap -r c112
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> tuning to 723000000 Hz
>> video pid 0x0120, audio pid 0x0121
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 1f | signal 0172 | snr 0172 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
> Are you amping up or splitting the signal in any way? If so, for test
> purposes remove anything that can degrade or improve RF. It looks like
> the tuner gets into lock briefly but falls out, implying abnormal RF
> conditions. When it locks you have perfect SNR, kind of implying that
> the signal may be too strong.
>
> Additionally, for all your testing, repeat the tests on tuner#2 by
> azap -a1 -r c112.
>
> Additionally, try channel 83 or edit the conf file and add some lower
> channels in the 40-80 range where the RF characteristics would be
> wildly different. I'd like to see how the card performs in these
> circumstances for you.
>
> Regards,
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>
