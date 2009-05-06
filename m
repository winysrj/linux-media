Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:44751 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZEFVTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 17:19:44 -0400
Received: by gxk10 with SMTP id 10so642796gxk.13
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 14:19:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
	 <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
	 <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com>
Date: Wed, 6 May 2009 17:19:44 -0400
Message-ID: <412bdbff0905061419tc7a5d0bt47bf744ec0c93cd2@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 6, 2009 at 5:02 PM, Britney Fransen
<britney.fransen@gmail.com> wrote:
> Did that and it still failed with the following (same as before):
> Playing dvb://2@FOX.
> FE_GET_INFO error: 19, FD: 4
>
> DVB CONFIGURATION IS EMPTY, exit
> Failed to open dvb://2@FOX.
>
> FOX is the first entry in my .mplayer/channels.conf file.
>
> Thanks,
> Britney

Also, you did stop the mythtv-backend daemon when you ran this test, right?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
