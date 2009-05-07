Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:56068 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZEGDze (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 23:55:34 -0400
Received: by yx-out-2324.google.com with SMTP id 3so326970yxj.1
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 20:55:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <47468C2F-83E4-4359-A1F2-7F59AC6A0E53@gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
	 <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
	 <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com>
	 <412bdbff0905061410k30d7114dk97cec1cc19c47b2b@mail.gmail.com>
	 <47468C2F-83E4-4359-A1F2-7F59AC6A0E53@gmail.com>
Date: Wed, 6 May 2009 23:55:34 -0400
Message-ID: <412bdbff0905062055k7cefb714wb496ef48464df99a@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 6, 2009 at 5:45 PM, Britney Fransen
<britney.fransen@gmail.com> wrote:
> I will try to help but it will be tomorrow before I can really get into it.
>

Britney,

If you do decide to narrow it down to a particular patch, please
switch over to the following tree first:

http://linuxtv.org/hg/~dheitmueller/xc5000-improvements-beta2

I re-exported the patch series and recreated the tree without all the
intermediate merges from the v4l-dvb tip.  As a result, it will be
much easier to bisect and determine which patch is causing the issue.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
