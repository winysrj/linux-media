Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbZJaJxk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 05:53:40 -0400
Message-ID: <4AEC08F0.70205@redhat.com>
Date: Sat, 31 Oct 2009 07:52:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] isl6421.c - added optional features: tone control and
 	temporary diseqc overcurrent
References: <846899810910241711s6fb5939fq3a693a92a2a76310@mail.gmail.com>
In-Reply-To: <846899810910241711s6fb5939fq3a693a92a2a76310@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HoP escreveu:
> Hi,
>
> this is my first kernel patch, so all comments are welcome.
>   
First of all, please check all your patches with checkpatch, to be sure
that they don't have any CodingStyle troubles. There are some on your
patch (the better is to read README.patches for more info useful
for developers).
> Attached patch adds two optional (so, disabled by default
> and therefore could not break any compatibility) features:
>
> 1, tone_control=1
> When enabled, ISL6421 overrides frontend's tone control
> function (fe->ops.set_tone) by its own one.
>   
On your comments, the better is to describe why someone would need
to use such option. You should also add a quick hint about that at the
option description.
> 2, overcurrent_enable=1
> When enabled, overcurrent protection is disabled during
> sending diseqc command. Such option is usable when ISL6421
> catch overcurrent threshold and starts limiting output.
> Note: protection is disabled only during sending
> of diseqc command, until next set_tone() usage.
> What typically means only max up to few hundreds of ms.
> WARNING: overcurrent_enable=1 is dangerous
> and can damage your device. Use with care
> and only if you really know what you do.
>   
I'm not sure if it is a good idea to have this... Why/when someone would 
need this?

If we go ahead and add this one, you should add a notice about it at the 
parameter.
I would also print a big WARNING message at the dmesg if the module were 
loaded
with this option turned on.
> /Honza
>
> Signed-off-by: Jan Petrous <jpetrous@gmail.com>
> ---
>   

