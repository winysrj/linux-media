Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:36546 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZEFVpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 17:45:54 -0400
Received: by gxk10 with SMTP id 10so671554gxk.13
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 14:45:53 -0700 (PDT)
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-Id: <47468C2F-83E4-4359-A1F2-7F59AC6A0E53@gmail.com>
From: Britney Fransen <britney.fransen@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0905061410k30d7114dk97cec1cc19c47b2b@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XC5000 improvements: call for testers!
Date: Wed, 6 May 2009 16:45:51 -0500
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com> <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com> <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com> <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com> <412bdbff0905061410k30d7114dk97cec1cc19c47b2b@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On May 6, 2009, at 4:10 PM, Devin Heitmueller wrote:
>
> Could you try using azap to tune?
>
> It seems like you have a basic tuning problem, independent of the
> application.  So, let's forget about MythTV for now and focus on the
> low level tools like mplayer/azap until we are confident that works.

Makes sense.  I will try azap next.

> If you want to help debug this, try rolling back the individual
> patches until you either get to the starting point of the series or
> the code starts working.  Once we know which patch causes it to start
> failing, we can go from there.

I will try to help but it will be tomorrow before I can really get  
into it.

> Also, you did stop the mythtv-backend daemon when you ran this test,  
> right?

Yes I did stop myth...frontend and backend.

Britney
