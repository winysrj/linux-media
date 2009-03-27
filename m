Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:43065 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZC0TAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 15:00:22 -0400
Message-ID: <49CD2232.4060701@gmail.com>
Date: Fri, 27 Mar 2009 23:00:02 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Mika Laitio <lamikr@pilppa.org>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org> <49C33DE7.1050906@gmail.com>	 <1237689919.3298.179.camel@palomino.walls.org>	 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>	 <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>	 <49C96A37.4020905@gmail.com>	 <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>	 <49C970C9.20407@gmail.com>	 <412bdbff0903250738l23a3b04fpdebbad502897bf57@mail.gmail.com>	 <49CAA9EC.8000904@gmail.com> <412bdbff0903251527i5fa6a534j17ce9dad4204da05@mail.gmail.com>
In-Reply-To: <412bdbff0903251527i5fa6a534j17ce9dad4204da05@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Wed, Mar 25, 2009 at 6:02 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Sure, of course. Here is an updated list based on the information
>> that you accumulated. I have corrected some of them, which were not
>> accurate.
> 
> Before I comment any further on your email, could you please clarify
> what you mean by "Relative, confirms to API".  The current DVB API
> specification does not specify any units of measure for the content of
> the field, so I am not sure what you mean by this.

Sorry about not responding earlier, wasn't feeling well at all and
hence.

By Relative, i meant dimensionless, but still it makes some sense
based on some documented references.

What i mean "relative" is that the API expects something like this.
http://linuxtv.org/hg/dvb-apps/file/5fbdd3f898b1/util/szap/README

Regards,
Manu
