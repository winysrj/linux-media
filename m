Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:58420 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1AMQ1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 11:27:34 -0500
Date: Thu, 13 Jan 2011 17:30:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-ID: <20110113173021.1f8a7b8b@tele>
In-Reply-To: <20110113123804.d391b10e.ospite@studenti.unina.it>
References: <20110113115953.4636c392@tele>
	<20110113123804.d391b10e.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 13 Jan 2011 12:38:04 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> > Jean-François Moine (9):  
> [...]
> >       gspca - ov534: Use the new video control mechanism  
> 
> In this commit, is there a reason why you didn't rename also
> sd_setagc() into setagc() like for the other functions?
> 
> I am going to test the changes and report back if there's anything
> more, I like the cleanup tho.

Hi Antonio,

With the new video control mechanism, the '.set_control' function is
called only when capture is active. Otherwise, the '.set' function is
called in any case, and here, it activates/inactivates the auto white
balance control... Oh, I forgot to disable the awb when the agc is
disabled!

Thank you for reporting any problem. BTW, the webcam 06f8:3002 which
had been removed some time ago is being tested. I will add it to this
subdriver as soon as it works correctly.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
