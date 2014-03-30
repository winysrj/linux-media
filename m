Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:48057 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaC3TQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 15:16:42 -0400
Received: by mail-qg0-f66.google.com with SMTP id a108so1713291qge.1
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 12:16:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz4whMp4hGiFCqE3++Z1Nmj2P=4wywQKQjeL+qgz67nag@mail.gmail.com>
References: <CALW6vT5P-Q-GHyRz7YGxyjx-RdVzhNVJA++mG1A1NbV_DGT8Mw@mail.gmail.com>
	<CAGoCfiz4whMp4hGiFCqE3++Z1Nmj2P=4wywQKQjeL+qgz67nag@mail.gmail.com>
Date: Sun, 30 Mar 2014 12:16:41 -0700
Message-ID: <CALW6vT5S5OUo2o=f6WYVep5ixuswrnffJCv-MX6MWL8gON6rhA@mail.gmail.com>
Subject: Re: No channels on Hauppauge 950Q
From: Sunset Machine <sunsetmachine7@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/30/14, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Sun, Mar 30, 2014 at 12:25 PM, Sunset Machine
> <sunsetmachine7@gmail.com> wrote:
>> Today is March 30, 2014
>>
>> The 950Q is a USB TV Stick. The driver loads, the firmware loads.
>> Various software sees the device but none of them find any channels. I
>> use an antenna for over-the-air HD television in the US. The device
>> works on Windows but not Linux (Debian 7.3, Squeeze).
>
> What kernel version are you using?  What applications have you tested
> with?  If you have a relatively recent version of the HVR-950q stick
> with a kernel older than 3.7, then you are likely to have issues with
> not having some required driver updates for the new tuner chip inside
> the unit.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

kernel 3.2.0-4-686-pae and a new 950q

3.13-1-686-pae is available in Debian testing.  I'll look into it.

TVTime, MythTV, Mplayer, Kaffeine, and w_scan. "scan" would oddly
leave the green signal light on when the program finished, as if it
were tuned, but reporting 0 channels found.
