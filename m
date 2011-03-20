Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:36901 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752424Ab1CTUpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 16:45:14 -0400
From: Jochen Reinwand <Jochen.Reinwand@gmx.de>
To: =?utf-8?q?Andr=C3=A9_Weidemann?= <Andre.Weidemann@web.de>
Subject: Re: Remote control TechnoTrend TT-connect S2-3650 CI
Date: Sun, 20 Mar 2011 21:45:11 +0100
Cc: linux-media@vger.kernel.org
References: <201103191940.20876.Jochen.Reinwand@gmx.de> <4D85005A.4080101@web.de>
In-Reply-To: <4D85005A.4080101@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201103202145.11493.Jochen.Reinwand@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi André,

Thanks for the help! I already fixed the problem! By accident...

On Saturday 19 March 2011, André Weidemann wrote:
> I don't think that this is a hardware problem. I think it is related to
> the driver. When I added support for the S2-3650CI to Dominik Kuhlen's
> code for the PC-TV452e, I used the RC-code function "pctv452e_rc_query"
> for the S2-3650CI. I ran into this problem back then and thought that
> setting .rc_interval to 500 would "fix" the problem good enough.

My first idea was simple: Set it to 1000. Better a slow remote control than  
double key presses. But the double key press events remained.
So I was planning to do some more debugging.
But my next idea was: If I get double events anyway, I can also speed up the 
remote by setting .rc_interval to 250. After setting it, everything was faster 
and ...  the double events disappeared!!! Of course, I did some further tests 
and found out that setting .rc_interval to 50 is also working perfectly! No 
double key press events so far and the remote is reacting really quick.

I don't really understand why this is fixing the issue...
Does it make sense to put this into the official repo? Or is it too dangerous? 
It's possibly breaking things for others...

Regards
Jochen
