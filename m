Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34594 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbLJMWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 07:22:41 -0500
Received: by ioir85 with SMTP id r85so90179267ioi.1
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2015 04:22:41 -0800 (PST)
Received: from [10.0.1.175] (dhcp-108-168-93-48.cable.user.start.ca. [108.168.93.48])
        by smtp.gmail.com with ESMTPSA id k83sm4994887iod.1.2015.12.10.04.22.39
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 10 Dec 2015 04:22:39 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: dtv-scan-table has two ATSC files?
From: Maury Markowitz <maury.markowitz@gmail.com>
In-Reply-To: <20151210075733.4abdcd16@recife.lan>
Date: Thu, 10 Dec 2015 07:22:39 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <434613F7-C1A1-4609-9553-136D7A903C36@gmail.com>
References: <201512081149525312370@gmail.com> <56687B09.4050004@kapsi.fi> <BF55C1DA-2E39-4ACA-92C0-4E512E10196F@gmail.com> <20151210075733.4abdcd16@recife.lan>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Dec 10, 2015, at 4:57 AM, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> Hmm... maybe we could, instead, keep one of them as a "complete" ATSC 
> possible channel list, and the other ones with the unregulated channels
> stripped.

OK I will upload a new patch “turning off” the unused channels. They will just be commented out.

> For terrestrial TV, those are unused, but perhaps the ATSC/NTSC
> channeling might still be used by some cable operator.

But that’s why there’s the us-Cable-XXX files? Isn’t this case is already handled?

> Also, those channeling files work on other Countries outside America,
> like South Korea.

I will make a kr-ATSC-center-frequencies-8VSB for this. And Mexico too.

And I volunteer for any other lingering documentation that needs doing.

> "us-ATSC-C-center-frequencies-8VSB" or even keeping it named as 
> "us-NTSC-center-frequencies-8VSB”.

This I can accept, but then one question: what is the right DELIVERY_SYSTEM = ? It would not be ATSC, is NTSC a proper value here?

