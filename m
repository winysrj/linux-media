Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:33058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZELUu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 16:50:58 -0400
Received: by ey-out-2122.google.com with SMTP id 9so88859eyd.37
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 13:50:57 -0700 (PDT)
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-Id: <87F5FF15-F869-4FEC-946B-C4D6D0C9506E@gmail.com>
From: Britney Fransen <britney.fransen@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0905062055k7cefb714wb496ef48464df99a@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XC5000 improvements: call for testers!
Date: Tue, 12 May 2009 15:50:52 -0500
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com> <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com> <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com> <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com> <412bdbff0905061410k30d7114dk97cec1cc19c47b2b@mail.gmail.com> <47468C2F-83E4-4359-A1F2-7F59AC6A0E53@gmail.com> <412bdbff0905062055k7cefb714wb496ef48464df99a@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On May 6, 2009, at 10:55 PM, Devin Heitmueller wrote:

>
> If you do decide to narrow it down to a particular patch, please
> switch over to the following tree first:
>
> http://linuxtv.org/hg/~dheitmueller/xc5000-improvements-beta2
>
> I re-exported the patch series and recreated the tree without all the
> intermediate merges from the v4l-dvb tip.  As a result, it will be
> much easier to bisect and determine which patch is causing the issue.
>

I finally had some time to do some more testing with the beta2 tree  
and I think most of the issues I had were user error.  Not exactly  
sure what I did wrong before but I am not seeing the reception issues  
or any regressions on the digital side anymore.  I think why I thought  
I was seeing QAM64 was because I was using the wrong tuner.  With the  
beta2 tree my 950q is now adapter1, before it was always adapter2.   
That could be part of what I thought was the reception regression as  
well.

Thanks,
Britney
