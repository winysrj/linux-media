Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab1FOOer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 10:34:47 -0400
Message-ID: <4DF8C32A.7090004@redhat.com>
Date: Wed, 15 Jun 2011 16:35:22 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com>
In-Reply-To: <4DF8C0D2.5070900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/15/2011 04:25 PM, Mauro Carvalho Chehab wrote:
> Em 15-06-2011 10:43, Hans de Goede escreveu:

<snip>

 >> Right, because ConsoleKit ensures that devices like floppydrives, cdroms, audio cards,
 >> webcams, etc. are only available to users sitting behind the console,
 >
 > This is a wrong assumption. There's no good reason why other users can't access those
 > devices.

This is not an assumption, this is a policy decision. The policy is that devices like
audiocards and webcams should be only available to local console users / processes. To
avoid for example someone from spying upon someone else sitting behind the computer.

<snip>

>>> 3) console, with mmap disabled:
>>>
>>> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
>>> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz
>>> write error: Input/output error
>>> ...
>>> write error: Input/output error
>>>
>>
>> This is a combination of the assumption there is a shared period size between
>> the input device and the output device + the broken error handling.
>
> The code is doing a negotiation, in order to find a period that are acceptable
> by both. Ok, there are other ways of doing it, but sharing the same period
> probably means less overhead.
>

This is what we call a premature optimization, there is not all that much
overhead here, and demanding that both sizes will support a share period size
may not always fly, and may likely lead to unnecessary large period sizes
and thus too much latency in some cases.

<snip>

> If you do some tests with mplayer and a few audio devices, you'll find that
> the audio performance may degrade the video streaming up to some point where
> you can't see the video stream. It is wise to offer a few options to the
> user, in order to allow workaround on that.

Since we're doing the audio from a separate thread here, and do no syncing
that cannot happen here. Also the right thing to do is to fix the code
to work under all circumstances not offer a gazillion cmdline options
and let the user figure out which ones happen to work for him.

Regards,

Hans
