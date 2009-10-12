Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59616 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbZJLWx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 18:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <f326ee1a0910121545o3a359b9cne477fadfe13c06e5@mail.gmail.com>
References: <f326ee1a0910121420j59d4f63dy1ffcb1636a9a63d1@mail.gmail.com>
	 <829197380910121448l1a9f35fmff276ad14afd9ac4@mail.gmail.com>
	 <f326ee1a0910121510q793fd06g7e704c31c0792713@mail.gmail.com>
	 <f326ee1a0910121545o3a359b9cne477fadfe13c06e5@mail.gmail.com>
Date: Mon, 12 Oct 2009 18:52:48 -0400
Message-ID: <829197380910121552r56b83604s551f14937897a655@mail.gmail.com>
Subject: Re: Kworld Analog TV 305U without audio - updated
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?D=EAnis_Goes?= <denishark@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	lauri.laanmets@proekspert.ee, grythumn@gmail.com,
	jarod@wilsonet.com, ridzevicius@gmail.com, xwang1976@email.it,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 6:45 PM, Dênis Goes <denishark@gmail.com> wrote:
> Hi...
>
> I was seeing in em28xx-cards.c in "KWorld DVB-T 305U" section, that is the
> more aproximate model for my card, and I have a doubt, my card is analog
> only (although it's 305U also), but the 305U in em28xx-cards.c have DVB-T,
> can be any parameter for card that causing the problem ?
>
> Thanks.

It's not clear why the product name says "DVB-T" since the board
profile that follows doesn't have a DVB-T definition.  Either way,
that's not having an effect on your issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
