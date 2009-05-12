Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f119.google.com ([209.85.216.119]:45491 "EHLO
	mail-px0-f119.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZELU4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 16:56:03 -0400
Received: by pxi17 with SMTP id 17so17515pxi.33
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 13:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87F5FF15-F869-4FEC-946B-C4D6D0C9506E@gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
	 <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
	 <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com>
	 <412bdbff0905061410k30d7114dk97cec1cc19c47b2b@mail.gmail.com>
	 <47468C2F-83E4-4359-A1F2-7F59AC6A0E53@gmail.com>
	 <412bdbff0905062055k7cefb714wb496ef48464df99a@mail.gmail.com>
	 <87F5FF15-F869-4FEC-946B-C4D6D0C9506E@gmail.com>
Date: Tue, 12 May 2009 16:56:03 -0400
Message-ID: <829197380905121356y1d76d73eu4738e3e926c11d27@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 12, 2009 at 4:50 PM, Britney Fransen
<britney.fransen@gmail.com> wrote:
> I finally had some time to do some more testing with the beta2 tree and I
> think most of the issues I had were user error.  Not exactly sure what I did
> wrong before but I am not seeing the reception issues or any regressions on
> the digital side anymore.  I think why I thought I was seeing QAM64 was
> because I was using the wrong tuner.  With the beta2 tree my 950q is now
> adapter1, before it was always adapter2.  That could be part of what I
> thought was the reception regression as well.
>
> Thanks,
> Britney

Hello Britney,

Thank you for taking the time to isolate/debug the situation.  The
changes should have no effect on the order of adapter1/adapter2.
Could have just been a coincidence or the order in which you plugged
in the devices compared to what they usually are at boot time.

Glad to see that there are no longer any issues.  Once I get one
outstanding Pinnacle 800i fix in, I will issue a PULL request and this
will go into the mainline.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
