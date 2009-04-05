Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s40.bay0.hotmail.com ([65.54.246.240]:45612 "EHLO
	bay0-omc3-s40.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759003AbZDEEK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 00:10:59 -0400
Message-ID: <BAY102-W466CBB0DF0E6662A739191CF870@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-15?= =?windows-1256?Q?00_tuner_s?=
 =?windows-1256?Q?eems_to_be?= =?windows-1256?Q?_recognize?=
 =?windows-1256?Q?d=2C_but_won?= =?windows-1256?Q?t_turn_on.?=
 =?windows-1256?Q?=FE?=
Date: Sat, 4 Apr 2009 23:10:57 -0500
In-Reply-To: <412bdbff0902171256y6545d970n6f7bd347f446ad7c@mail.gmail.com>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
 	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
 	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
 	 <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
 	 <BAY102-W41AFA57978CB8940FABF84CFB40@phx.gbl>
 	 <412bdbff0902171021l6bcfc1f4o6d4903949da70b0d@mail.gmail.com>
 	 <BAY102-W289218AB686D66E1F3BD4ACFB40@phx.gbl>
 	 <412bdbff0902171245m5e6a8deerfcd14a340f65fa4f@mail.gmail.com>
 	 <BAY102-W2159CF565B5E47F670249DCFB40@phx.gbl>
 <412bdbff0902171256y6545d970n6f7bd347f446ad7c@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Finally found more time to work on this.  When i try 

sudo modprobe tuner-xc2028 no_poweroff=1


It returns:

tuner_xc2028: Unknown parameter `no_poweroff'


any thoughts?


Nick



----------------------------------------
> Date: Tue, 17 Feb 2009 15:56:00 -0500
> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
> From: devin.heitmueller@gmail.com
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
>
> 2009/2/17 Thomas Nicolai :
>>
>> I will try those suggestions this evening. did he feel this should be done in addition to the modprobe tunerxc-2028 no_poweroff=1 debug=1 ?
>
> Please do both commands. That way we will get both sets of debugging
> messages and you only have to do the capture once.
>
> Regards,
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

_________________________________________________________________
Rediscover Hotmail®: Now available on your iPhone or BlackBerry
http://windowslive.com/RediscoverHotmail?ocid=TXT_TAGLM_WL_HM_Rediscover_Mobile1_042009
