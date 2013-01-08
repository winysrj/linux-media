Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:48128 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3AHWKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 17:10:37 -0500
Received: by mail-ia0-f172.google.com with SMTP id u8so217890iag.17
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 14:10:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EC93B0.8030404@iki.fi>
References: <CA+rnASviBDZVk9KJPYD1jLoHUbeyWwL+D5oSyvYVHKZFOSUAkw@mail.gmail.com>
 <50EC93B0.8030404@iki.fi>
From: =?UTF-8?Q?C=C3=A9dric_Girard?= <girard.cedric@gmail.com>
Date: Tue, 8 Jan 2013 23:10:16 +0100
Message-ID: <CA+rnASsrDc57FkMi=nWzDThFNc9ktj2J60XcA7WCWisLyrxxgw@mail.gmail.com>
Subject: Re: No Signal with TerraTec Cinergy T PCIe dual
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 8, 2013 at 10:46 PM, Antti Palosaari wrote:
> On 01/08/2013 11:02 PM, Cédric Girard wrote:
>> Meaningful bits of an strace of the same command
>> ###
>> ioctl(3, FE_READ_STATUS, 0x7fff69172ef0) = 0
>> ioctl(3, FE_READ_BER, 0x7fff69173018)   = -1 EAGAIN (Resource
>> temporarily unavailable)
>> ioctl(3, FE_READ_SIGNAL_STRENGTH, 0x7fff6917301c) = -1 EAGAIN
>> (Resource temporarily unavailable)
>> ioctl(3, FE_READ_SNR, 0x7fff6917301e)   = -1 EAGAIN (Resource
>> temporarily unavailable)
>> ioctl(3, FE_READ_UNCORRECTED_BLOCKS, 0x7fff69173020) = -1 EAGAIN
>> (Resource temporarily unavailable)
>> ###
>
>
> I could guess these errors are coming because you query statistics but
> device is sleeping and statistics cannot be offered. -EAGAIN == device is
> sleeping, -ENOTTY device does not support given statistic at all.
>
> Could you ensure that? Use some app, like w_scan, tzap, czap, etc. to tune
> and recheck if it shows these or not. femon could not tune, it queries only
> statistics. You will need to leave tuning on and then use other terminal for
> femon.

You were right. Now I get this while running w_scan in another terminal:
###
status SCV   | signal   5% | snr   0% | ber 0 | unc 0 |
status SCV   | signal   5% | snr   0% | ber 0 | unc 0 |
status SCV   | signal   5% | snr   0% | ber 0 | unc 0 |
[...]
###

This is coherent with the "no signal" result.

>
>
>> w_scan give "no signal" result.
>> dvbscan give "Unable to query frontend status"
>
>
> hmm, that dvbscan results sounds crazy. I am not sure about these scanning
> apps as there is scan, dvbscan, scandvb. Maybe some of those, or even all,
> are just same app but renamed as "scan" is too general. My Fedora 17 has
> scandvb. I just tested against one DRX-K device and it worked fine.

According to the wiki [1] scandvb is a distro-side renaming of dvbscan.


>
>
>> Any hint to where I should look would be welcome!
>
>
> Try to downgrade Kernels until you find working one.

Guess it is probably the only way. I will try.

[1] http://linuxtv.org/wiki/index.php/Dvbscan

--
Cédric Girard
