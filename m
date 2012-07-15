Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56231 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GONZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 09:25:24 -0400
Received: by bkwj10 with SMTP id j10so4120205bkw.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jul 2012 06:25:22 -0700 (PDT)
Message-ID: <5002C4BE.4030108@gmail.com>
Date: Sun, 15 Jul 2012 15:25:18 +0200
From: Michael Schmitt <tcwardrobe@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Jarod Wilson <jarod@redhat.com>,
	linux-media <linux-media@vger.kernel.org>, 677727@bugs.debian.org
Subject: Re: [3.2->3.3 regression] mceusb: only every second keypress is recognised
References: <20120616142624.11863.63977.reportbug@ganymed.tcw.local> <1339865057.4942.184.camel@deadeye.wl.decadent.org.uk> <4FDE4C13.8030308@gmail.com> <1339978963.4942.273.camel@deadeye.wl.decadent.org.uk> <4FDF2B39.1000402@gmail.com> <1340340750.6871.212.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1340340750.6871.212.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Did this issue drop under everybodys radar? :)

I am the person that reported that bug in the Debian bugtracker a month 
ago and I find it hard to believe no-one else can at least confirm that 
issue. As I have seen a second box with Debian wheezy and kernel 3.4 
(needed because of radeon-hdmi-sound) with the *same* issue, but I think 
a different receiver (can't check that right now but it is a Zotac Zbox 
mini AD10 built-in IR-receiver). With kernel 3.2 no issue, with 3.4 only 
every second keypress recognized.

Any thoughts about that issue would be greatly appreciated! And are 
there any other users out there having such kernel-related issues? Maybe 
some change in the kernel now needs a different kind of setup for lirc? 
Maybe similar to the switch from lirc drivers to in-kernel lirc / 
devinput? Just guessing here...

regards
Michael

Am 22.06.2012 06:52, schrieb Ben Hutchings:
> [Full bug log is at<http://bugs.debian.org/677727>.]
>
> On Mon, 2012-06-18 at 15:20 +0200, Michael Schmitt wrote:
>> Hi Ben,
>>
>> mschmitt@ganymed:~$ dmesg |head -3
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.3.0-rc6-686-pae (Debian
>> 3.3~rc6-1~experimental.1) (debian-kernel@lists.debian.org) (gcc version
>> 4.6.3 (Debian 4.6.3-1) ) #1 SMP Mon Mar 5 21:21:52 UTC 2012
>>
>> that is the first kernel I found on snapshot.d.o that does show that
>> issue. The next one backwards is "linux-image-3.2.0-2-686-pae
>> (3.2.20-1)" and that one works.
>>
>> Is there anything that comes to your mind?
> No, but this version information should help to track down how the bug
> was introduced.
>
> Michael originally wrote:
>> with the current kernel from experimental only every second keypress is
>> recognized on my ir remote control. Reboot to kernel 3.2 from sid, all back to
>> normal.
>> I have no idea how the kernel could be responsible there... ok, a weird bug in
>> the responsible kernel module for the remote, but somehow I doubt that.
> The driver in question is mceusb.
>
> Ben.
>

