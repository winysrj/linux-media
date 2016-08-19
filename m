Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36484 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbcHSOCP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 10:02:15 -0400
Received: by mail-oi0-f43.google.com with SMTP id f189so64346041oig.3
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2016 07:01:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2fb767603a2e450a89ab263e2224026e@MBX06A-IAD3.mex08.mlsrvr.com>
References: <2d1d06c05dae478b9bc2484e9d1da36c@MBX06A-IAD3.mex08.mlsrvr.com>
 <20160817105822.7fum27zgz2e3hf4o@acer> <2fb767603a2e450a89ab263e2224026e@MBX06A-IAD3.mex08.mlsrvr.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Fri, 19 Aug 2016 10:01:16 -0400
Message-ID: <CAGoCfixmx7hoCDT9a3HfwHDdtxyW9Y1SgvgpyiZn9BNPf8eqkQ@mail.gmail.com>
Subject: Re: Linux support for current StarTech analog video capture device (SAA711xx)
To: Steve Preston <stevepr@netstevepr.com>
Cc: Andrey Utkin <andrey_utkin@fastmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

> We have two models of the StarTech in use: SVID2USB2 and SVID2USB23.  The "23" version is the only version currently listed on StarTech's website.  It is available via Amazon in the USA but I'm not sure about other countries.

Have you actually opened these units up and confirmed what chips are
inside of them?  Or did you determine it's em28xx/saa711x via a Google
search.  The reason I ask is many of these devices will quietly change
their internal design over time, without changing the plastics and/or
model number.  Hence you cannot simply rely on what somebody else may
have said in terms of what chips are inside the device you're holding
in your hand.

First step would probably be to confirm the chips in question.  If
they really are based on the em2882/saa7115, then it should be pretty
easy to get working with a minor code change to the driver.

If you're in the US and you're willing to throw it in a USPS flat rate
box and ship it to me, I can probably have it working in about an
hour.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
