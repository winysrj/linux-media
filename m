Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab1BTIOa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 03:14:30 -0500
Message-ID: <4D60CD6D.6000607@redhat.com>
Date: Sun, 20 Feb 2011 09:14:37 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mike Booth <mike_booth76@iprimus.com.au>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-utils-0.8.3 and KVDR
References: <e05367$6mkr9m@smtp06.syd.iprimus.net.au>
In-Reply-To: <e05367$6mkr9m@smtp06.syd.iprimus.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 02/20/2011 12:48 AM, Mike Booth wrote:
> My understanding of the "wrappers"contained in this library is that v4l
> applications should work with kernels from 2.6.36 onwards if the compat.so is
> preloaded.
>
> I use KVDR for watching and controlling VDR on my TV.
>
> Xine and Xineliboutput or not options as they don't provide TV out and TV out
> fronm the video card is also not an option because of where things are in the
> house.
>
> KVDR fails with
>
>
> Xv-VIDIOCGCAP: Invalid argument
> Xv-VIDIOCGMBUF: Invalid argument
>
> works perfectly fine on linux-2.6.35
>
>
> Anyone have any ideas

First of all make sure you load kdvr with the appropriote LD_PRELOAD, ie:
LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so kvdr

If that does not help, do the following before launching kvdr:
export LIBV4L1_LOG_FILENAME=/tmp/log

So the total sequence of commands becomes:
export LIBV4L1_LOG_FILENAME=/tmp/log
LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so kvdr

Then do what ever you want to do and fails, and send another mail
with /tmp/log attached.

Regards,

Hans

