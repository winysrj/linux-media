Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:7652 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBQUpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 15:45:54 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1176452ywh.1
        for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 12:45:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BAY102-W289218AB686D66E1F3BD4ACFB40@phx.gbl>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
	 <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
	 <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
	 <BAY102-W41AFA57978CB8940FABF84CFB40@phx.gbl>
	 <412bdbff0902171021l6bcfc1f4o6d4903949da70b0d@mail.gmail.com>
	 <BAY102-W289218AB686D66E1F3BD4ACFB40@phx.gbl>
Date: Tue, 17 Feb 2009 15:45:53 -0500
Message-ID: <412bdbff0902171245m5e6a8deerfcd14a340f65fa4f@mail.gmail.com>
Subject: =?windows-1256?Q?Re=3A_HVR=2D1500_tuner_seems_to_be_recognized=2C_but_wont_?=
	=?windows-1256?Q?turn_on=2E=FE?=
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Thomas Nicolai <nickotym@hotmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/17 Thomas Nicolai <nickotym@hotmail.com>:
>
> I didn't post it last night, but I don't remember seeing anything different in it after I looked at it.  I haven't seen much on the mailing lists about it not working.  I found a few threads on Kubuntu and Ubuntu forums about people having problems a few months ago, but they were all able to get the card to tune, some had issues with sound that were later resolved.  Noone said they couldn't get it to tune.
>
> You mentioned that the card causing the computer to freeze may indicate other problems, could hotplug not working right affect this?
>
> I will try some more tonight.

Thomas,

I spoke to Steven Toth about this issue, and he suggested also running
the following commands prior to plugging in the device:

sudo modprobe cx23885 i2c_scan=1
md5sum /lib/firmware/*/xc*
md5sum /lib/firmware/xc*

And include the output from dmesg, as well as the output of running
the two md5sum commands.

Regards,

Devin
-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
