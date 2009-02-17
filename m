Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s14.bay0.hotmail.com ([65.54.246.214]:48621 "EHLO
	bay0-omc3-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbZBQUvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 15:51:53 -0500
Message-ID: <BAY102-W2159CF565B5E47F670249DCFB40@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-1500_tuner_seems_to_be_recognized=2C_but_wont_tu?=
 =?windows-1256?Q?rn_on.=FE?=
Date: Tue, 17 Feb 2009 14:51:52 -0600
In-Reply-To: <412bdbff0902171245m5e6a8deerfcd14a340f65fa4f@mail.gmail.com>
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
 <412bdbff0902171245m5e6a8deerfcd14a340f65fa4f@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I will try those suggestions this evening.  did he feel this should be done in addition to the modprobe tunerxc-2028 no_poweroff=1 debug=1  ?

----------------------------------------
> Date: Tue, 17 Feb 2009 15:45:53 -0500
> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
> From: devin.heitmueller@gmail.com
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
>
> 2009/2/17 Thomas Nicolai :
>>
>> I didn't post it last night, but I don't remember seeing anything different in it after I looked at it. I haven't seen much on the mailing lists about it not working. I found a few threads on Kubuntu and Ubuntu forums about people having problems a few months ago, but they were all able to get the card to tune, some had issues with sound that were later resolved. Noone said they couldn't get it to tune.
>>
>> You mentioned that the card causing the computer to freeze may indicate other problems, could hotplug not working right affect this?
>>
>> I will try some more tonight.
>
> Thomas,
>
> I spoke to Steven Toth about this issue, and he suggested also running
> the following commands prior to plugging in the device:
>
> sudo modprobe cx23885 i2c_scan=1
> md5sum /lib/firmware/*/xc*
> md5sum /lib/firmware/xc*
>
> And include the output from dmesg, as well as the output of running
> the two md5sum commands.
>
> Regards,
>
> Devin
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t2_allup_howitworks_022009
