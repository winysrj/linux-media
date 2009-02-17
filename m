Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s24.bay0.hotmail.com ([65.54.246.224]:65140 "EHLO
	bay0-omc3-s24.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbZBQSGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 13:06:30 -0500
Message-ID: <BAY102-W9861ED8EFCFABC404905FCFB40@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-1500_tuner_seems_to_be_recognized=2C_but_wont_tu?=
 =?windows-1256?Q?rn_on.=FE?=
Date: Tue, 17 Feb 2009 12:06:29 -0600
In-Reply-To: <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
  	 <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
  	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
  	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
  	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
  <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>






After trying your fix a few times last night I gave up.  I was really hoping that would do it.  I think this evening I will try reinstalling the drivers and see if maybe something got corrupted or maybe a change has been made in my favor.  Otherwise I may try reinstalling the i2c core.

thanks,

Tom

> Date: Tue, 17 Feb 2009 00:48:53 -0500
> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
> From: devin.heitmueller@gmail.com
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
> 
> 2009/2/17 Thomas Nicolai :
>>
>> I have tried this a couple times, but when I unplug the card, the computer freezes.  Any solutions to that?  Will it work to do the modprobe you listed after turning the computer on and leaving the card out, then putting it in and then doing the modprobe?
> 
> Are you saying that independent of the steps I provided the computer
> always freezes when you unplug the card?  If so, then that's a
> separate issue that should be investigated.
> 
> But to answer your question, yes you should be able to achieve the
> same result by leaving the card out, booting up, doing the modprobe,
> and plugging the card in (as long as you don't have any other tuners
> installed in your PC that use the xc3028 tuner).
> 
> Devin
> 
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Windows Live™: E-mail. Chat. Share. Get more ways to connect.  Check it out.
_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/explore?ocid=TXT_TAGLM_WL_t2_allup_explore_022009
