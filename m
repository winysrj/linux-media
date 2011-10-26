Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46536 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1JZTtL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 15:49:11 -0400
Received: by bkbzt19 with SMTP id zt19so1941801bkb.19
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 12:49:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA86366.1020906@lockie.ca>
References: <4EA78E3C.2020308@lockie.ca>
	<CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com>
	<4EA86366.1020906@lockie.ca>
Date: Wed, 26 Oct 2011 15:49:10 -0400
Message-ID: <CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com>
Subject: Re: femon signal strength
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2011 at 3:45 PM, James <bjlockie@lockie.ca> wrote:
> How many different formats are there (do I have to go through the archive)?
> Would it be feasable to change femon to handle different formats?

There are three or four common formats, and there is no real way for
an application to know which format was used unless it perhaps
hard-codes some table of demodulator driver names into the source
(which by the way will cause breakage if efforts are made to change
the demods to use a common format).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
