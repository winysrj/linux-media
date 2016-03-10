Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:40374 "EHLO smtp3.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbcCJR6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 12:58:12 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: DVBv5 Tools: VDR support seems to be broken (recommended patch)
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <CAA7C2qhER5Yzm3R5ReeAOc7u2JydN4FhankzspYqZ-P1wgUV6g@mail.gmail.com>
Date: Thu, 10 Mar 2016 18:57:58 +0100
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <D0060DD9-D5CD-43BC-81B4-C38399BE1068@darmarit.de>
References: <19129703-C076-47F7-BEFF-8A57D172132D@darmarit.de> <EFEC860B-B1FC-499D-911C-61DC3C0A9517@darmarit.de> <CAA7C2qhER5Yzm3R5ReeAOc7u2JydN4FhankzspYqZ-P1wgUV6g@mail.gmail.com>
To: VDR User <user.vdr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, but can't find the point in deep (in dvbdevice.c),
may you can point more precise.

I only found a part in a other file which confirms me to "A".
The question is: are there are any application which use
the orbital position in degrees? which is a pedantic question
as long, as orbital positions not covered by dvbv5.

--M--

Am 10.03.2016 um 16:38 schrieb VDR User <user.vdr@gmail.com>:

>> There is only one point I have a doubt: I have no ATSC
>> experience (I'am in Europe/germ), so I simply added
>> an "A" at the field "satellite pos.". This is what
>> the w_scan tool does and this tool works fine with
>> the vdr (please correct me if I'am wrong).
> 
> Instead of guessing about ATSC, why not look at the VDR source code
> and get a definitive answer? I believe you'll find what you're looking
> for in: dvbdevice.c

