Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:56397 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZBYDYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 22:24:38 -0500
Received: by fxm11 with SMTP id 11so3389620fxm.13
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 19:24:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d9def9db0902241606i763a4c21o2a180c5e2dcbb778@mail.gmail.com>
References: <200902221115.01464.hverkuil@xs4all.nl>
	 <200902242119.17436.hverkuil@xs4all.nl>
	 <49A407B0.8C56.0056.0@matc.edu>
	 <d9def9db0902241606i763a4c21o2a180c5e2dcbb778@mail.gmail.com>
Date: Wed, 25 Feb 2009 04:24:34 +0100
Message-ID: <d9def9db0902241924ic0916a1x21438e7fef56ad9d@mail.gmail.com>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: Markus Rechberger <mrechberger@gmail.com>
To: Jonathan Johnson <johnsonn@matc.edu>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 25, 2009 at 1:06 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Tue, Feb 24, 2009 at 9:43 PM, Jonathan Johnson <johnsonn@matc.edu> wrote:
>> Hello all,
>>
>> My vote is YES, why haven't we done this already??
>>
>> My understanding is that we are just drop old kernel support and retaining the vast majority of the drivers.
>> If anyone tallied the total number CVE listed vulernabilites and other problems fixed since then they would probably be shocked.
>> Unless for some reason your hardware is so old that it does support 2.6.28.7, this is the version you should run.
>>
>> Later,
>> Jonathan
>>
>>>>> Hans Verkuil <hverkuil@xs4all.nl> 2/24/2009 2:19 PM >>>
>> Please reply to this poll if you haven't done so yet. I only count clear
>> yes/no answers, so if you replied earlier to this in order to discuss a
>> point then I haven't counted that.
>>
>> Currently it's 16 yes and 2 no votes, but I'd really like to see some more
>> input. I want to post the final results on Sunday.
>>
>> Regards,
>>
>>        Hans
>>
>> On Sunday 22 February 2009 11:15:01 you wrote:
>>> Hi all,
>>>
>>> There are lot's of discussions, but it can be hard sometimes to actually
>>> determine someone's opinion.
>>>
>>> So here is a quick poll, please reply either to the list or directly to
>>> me with your yes/no answer and (optional but welcome) a short explanation
>>> to your standpoint. It doesn't matter if you are a user or developer, I'd
>>> like to see your opinion regardless.
>>>
>>> Please DO NOT reply to the replies, I'll summarize the results in a
>>> week's time and then we can discuss it further.
>>>
>>> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>>>
>>> _: Yes
>>> _: No
>>>
>
> don't care
>
>>> Optional question:
>>>
>>> Why:
>>>
>
> analog TV didn't work for me anyway < 2.6.18 not sure if it got fixed up
> timers are horribly modified within 2.6.18 - now, something that
> worked back then might not work properly anymore now.
> remote control support has a horrible bug, I reported something a half
> year ago..
> although the solution I use to provide is to move the frontend and
> configuration layer to userland and only having the data transfer API
> in the kernel (this includes v4l2 - latest API and the entire dvb core
> API).
> http://mcentral.de/wiki/index.php5/DVBConfigFramework it's infront of
> the API access and the applications make use of it using LD_PRELOAD.
> Customers mostly use to compile the em28xx driver from mcentral.de
> against the currently installed drivers which come with the native
> kernel, or I use to deliver binaries. Now the DVB config framework
> makes use of usbfs (similar like libusbfs) in my case and also works
> on OSX with exactly the same drivers.
>

one more thing to add here,

the usb devices always have the same USB transfer, but different
configuration block.
there's libv4l2 which I think of inheriting within the userland daemon
since it also intercepts the calls.
A good interface would more or less be to add custom vendor ids and
custom product ids including custom
capabilities eg. enable transfer for analog TV, DVB-T, DVB-C, ATSC,
DMB-TH, ISDB-T...

Since I now have that framework which can more or less also work with
the existing em28xx kernel driver it might be an interesting question.
And since it's in userland the compatibility is also pretty good
(basically everything that supports dumping the data to userland for
v4l and the same for DVB) hybrid or non hybrid doesn't really matter
the daemon and lib will take care about this.

We also have libv4l2 in userland which knows about device specific
decoding algorithms, so there's already a kernel-userland dependency
here.

http://mcentral.de/wiki/index.php5/Terratec_HTC_XS

this is the first device which only relies on the data dump capability
of the em28xx driver, and overrides all the configuration issues (and
again there's no extra kernel module needed to override all this).
Basic dump capability of data exists since a very long time in the
v4l-dvb API - this is the main reason why backward compatibility is no
issue for me anymore.

http://mcentral.de/wiki/index.php5/DVBConfigFramework

interested people currently have access to the core userland API
already feel free to drop me a line if you want to know more about it.

regards,
Markus
