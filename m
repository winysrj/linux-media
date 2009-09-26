Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41967 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbZIZU7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 16:59:52 -0400
Received: by bwz6 with SMTP id 6so587840bwz.37
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 13:59:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090925221015.GA21295@zverina>
References: <20090913193118.GA12659@zverina>
	 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
	 <20090921221505.GA5187@zverina>
	 <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
	 <20090922091235.GA10335@zverina>
	 <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
	 <20090925172209.GA10054@zverina>
	 <829197380909251041i637a0790g10cc4b82a791f695@mail.gmail.com>
	 <20090925182213.GA6941@zverina> <20090925221015.GA21295@zverina>
Date: Sat, 26 Sep 2009 16:59:54 -0400
Message-ID: <829197380909261359l22588d31v6fcc2cef40b12acd@mail.gmail.com>
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 25, 2009 at 6:10 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> Alright, success!!!
>
> Since it seems everything for this tuner is set up the same as for the
> Hauppauge WinTV HVR 900, I figured let's set things up *exactly* the
> same. So, like it's there for the Hauppauge, I added .mts_firmware = 1
> to the definition of the hybrid XS em2882. And well, working TV audio!!
>
>
> dmesg output this time:
>
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> MTS (4), id 00000000000000ff:
> xc2028 4-0061: Loading firmware for type=MTS (4), id 0000000100000007.
>
>
> So now with the attached patch, everything (analog, digital, remote)
> works!
>
> Regards,
> Uroš
>

Hello Uros,

Please test out the following tree, which has all the relevant fixes
(enabling dvb, your audio fix, proper gpio setting, etc).

http://kernellabs.com/hg/~dheitmueller/misc-fixes2/

If you have any trouble, please let me know.  Otherwise I would like
to issue a PULL request for this tree.

Thanks,

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
