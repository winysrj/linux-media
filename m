Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:31663 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZEHNyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2009 09:54:38 -0400
Received: by yw-out-2324.google.com with SMTP id 5so835345ywb.1
        for <linux-media@vger.kernel.org>; Fri, 08 May 2009 06:54:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A02C426.2030703@wowway.com>
References: <4A02C426.2030703@wowway.com>
Date: Fri, 8 May 2009 09:54:39 -0400
Message-ID: <412bdbff0905080654m425b36a6naa540e3fc24343d@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: "John R." <johnr@wowway.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 7, 2009 at 7:21 AM, John R. <johnr@wowway.com> wrote:
> After some off-list pointers by Devin, I tracked this down to user error.  I
> thought I was compiling tip for xc5000-improvements-beta but was not.  This
> is now working and composite input video works well on my 950Q.  I notice no
> difference from previous version (wouldn't really expect to based on
> changes).
>
> Thanks,
>
> John

Glad to hear it's working for you.  If you're using composite, then
you will not see the benefits of the tuning performance, but you
*will* see the power management benefits.  This means the tuner chip
won't be enabled when you're not watching TV, which will result in not
causing as much drain on your battery (if you have a laptop) and the
device will be much cooler.

I am still looking for strategies in the code so that the tuner is not
enabled when capturing on composite or s-video (which will reduce
power consumption further), but the code changes are non-trivial.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
