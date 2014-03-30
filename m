Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f193.google.com ([209.85.216.193]:57406 "EHLO
	mail-qc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaC3XEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 19:04:04 -0400
Received: by mail-qc0-f193.google.com with SMTP id e16so2453972qcx.8
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 16:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyaNi+LNY5iCjtE-PN8DP+3qiH5Sc=2BMwyt8zpxhYvWA@mail.gmail.com>
References: <CALW6vT5P-Q-GHyRz7YGxyjx-RdVzhNVJA++mG1A1NbV_DGT8Mw@mail.gmail.com>
	<CAGoCfiz4whMp4hGiFCqE3++Z1Nmj2P=4wywQKQjeL+qgz67nag@mail.gmail.com>
	<CALW6vT5S5OUo2o=f6WYVep5ixuswrnffJCv-MX6MWL8gON6rhA@mail.gmail.com>
	<CAGoCfiyaNi+LNY5iCjtE-PN8DP+3qiH5Sc=2BMwyt8zpxhYvWA@mail.gmail.com>
Date: Sun, 30 Mar 2014 16:04:03 -0700
Message-ID: <CALW6vT4zpSFa5yhLtrU-9wojCk+QoMVpjOnRkSh71Fy5Q=AqJg@mail.gmail.com>
Subject: Re: No channels on Hauppauge 950Q
From: Sunset Machine <sunsetmachine7@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/30/14, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Sun, Mar 30, 2014 at 3:16 PM, Sunset Machine
> <sunsetmachine7@gmail.com> wrote:
>> kernel 3.2.0-4-686-pae and a new 950q
>
> Ok.  If you own a Revision E1H3 device, then that kernel definitely
> won't work (the Rev is printed on the back of the stick above the
> barcode).

It is an E1H3, and I have good news. After upgrading the kernel to
3.13 and the firmware, I ran w_scan and it found several channels.
Creating a channels.conf with w_scan and running the command "mplayer
dvb://ThisTV" soon had my local channel up on the screen.

Think I'll go kill some time now. :-)

Thank you!
