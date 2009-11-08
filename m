Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64992 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZKHXzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 18:55:46 -0500
Received: by bwz27 with SMTP id 27so2940832bwz.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 15:55:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF75844.2040601@gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
	 <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
	 <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
	 <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
	 <702870ef0911070328v4d39afd9kc2469fb3e78ba203@mail.gmail.com>
	 <829197380911071840l41fbaa8et58641ea99ad79b94@mail.gmail.com>
	 <829197380911080616r32a35653u584dd24f25332284@mail.gmail.com>
	 <4AF75844.2040601@gmail.com>
Date: Sun, 8 Nov 2009 18:55:50 -0500
Message-ID: <829197380911081555maf3a53do856e7699598cd5ef@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Barry Williams <bazzawill@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 8, 2009 at 6:46 PM, Barry Williams <bazzawill@gmail.com> wrote:
> Where would I find your local tree as I can't seem to get the patch to
> apply and I would like to take advantage of this patch asap.
> Thanks
> Barry

I pushed out my tree with the fix:

http://kernellabs.com/hg/~dheitmueller/misc-fixes-4

I haven't issued a PULL yet to put it into the mainline since I have a
couple of other things pending.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
