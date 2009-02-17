Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s23.bay0.hotmail.com ([65.54.246.223]:27580 "EHLO
	bay0-omc3-s23.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbZBQSrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 13:47:09 -0500
Message-ID: <BAY102-W289218AB686D66E1F3BD4ACFB40@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-1500_tuner_seems_to_be_recognized=2C_but_wont_tu?=
 =?windows-1256?Q?rn_on.=FE?=
Date: Tue, 17 Feb 2009 12:47:08 -0600
In-Reply-To: <412bdbff0902171021l6bcfc1f4o6d4903949da70b0d@mail.gmail.com>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
 	 <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
 	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
 	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
 	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
 	 <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
 	 <BAY102-W41AFA57978CB8940FABF84CFB40@phx.gbl>
 <412bdbff0902171021l6bcfc1f4o6d4903949da70b0d@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I didn't post it last night, but I don't remember seeing anything different in it after I looked at it.  I haven't seen much on the mailing lists about it not working.  I found a few threads on Kubuntu and Ubuntu forums about people having problems a few months ago, but they were all able to get the card to tune, some had issues with sound that were later resolved.  Noone said they couldn't get it to tune.  

You mentioned that the card causing the computer to freeze may indicate other problems, could hotplug not working right affect this?

I will try some more tonight.

----------------------------------------
> Date: Tue, 17 Feb 2009 13:21:05 -0500
> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
> From: devin.heitmueller@gmail.com
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
>
> 2009/2/17 Thomas Nicolai :
>> After trying your fix a few times last night I gave up. I was really hoping
>> that would do it. I think this evening I will try reinstalling the drivers
>> and see if maybe something got corrupted or maybe a change has been made in
>> my favor. Otherwise I may try reinstalling the i2c core.
>>
>> thanks,
>>
>> Tom
>
> Just to be clear, the v4l-dvb codebase doesn't contain the i2c core.
> That ships as a standard part of your kernel. You're not really going
> to be able to "reinstall the i2c core" unless you mean reinstalling
> the latest kernel package that came with your distro or recompiling
> the kernel.
>
> Hmm... Could also be an issue with the i2c gate preventing
> communications from reaching the tuner.
>
> Is anyone else reporting success with this card in the current v4l-dvb
> build? I'm wondering if this is some issue specific to your
> environment, or whether the card is just broken in the latest build in
> general.
>
> Did you post the dmesg output after adding "debug=1" to the
> tuner-xc2028 modprobe option and trying to tune to a station?
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

_________________________________________________________________
Windows Live™: Keep your life in sync. 
http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t1_allup_howitworks_022009
