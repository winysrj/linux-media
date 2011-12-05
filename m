Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1LEXh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 18:37:28 -0500
Received: by faar15 with SMTP id r15so1229712faa.19
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2011 15:37:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfizgkfHJ-0YwcdTEQEhci=7eE7BTuSOj8KmMpLRhc4oqGg@mail.gmail.com>
References: <4ED929E7.2050808@gmail.com> <CAGoCfizgkfHJ-0YwcdTEQEhci=7eE7BTuSOj8KmMpLRhc4oqGg@mail.gmail.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Tue, 6 Dec 2011 00:37:06 +0100
Message-ID: <CAKdnbx5vewR3bLvFD4DeGiOSa8AqP0hupVF2jf1w9xrizXYz1g@mail.gmail.com>
Subject: Re: Hauppauge HVR-930C problems
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

try using scan from dvb-apps and not w_scan.

Actually It seems to me w_scan isn't compatible with this driver due
some missing lock.

On Fri, Dec 2, 2011 at 8:45 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, Dec 2, 2011 at 2:41 PM, Fredrik Lingvall
> <fredrik.lingvall@gmail.com> wrote:
>> The HVR 930C device has three connectors/inputs:  an antenna input, an
>> S-video, and a composite video, respectively,
>>
>> The provider I have here in Norway (Get) has both analog tv and digital
>> (DVB-C) so can I get analog tv using the antenna input or is analog only on
>> the S-video/composite inputs? And, how do I select which analog input that
>>  is used?
>
> The analog support for that device isn't currently supported (due to a
> lack of a Linux driver for the analog demodulator).  The digital
> should work fine though (and if not, bring it to Mauro's attention
> since he has been actively working on it).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
