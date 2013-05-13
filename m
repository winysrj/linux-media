Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51070 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3EMJ5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:57:36 -0400
Received: by mail-we0-f174.google.com with SMTP id x53so5996635wes.33
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368438071.1350.43.camel@x61.thuisdomein>
References: <1363079692-16683-1-git-send-email-nsekhar@ti.com> <1368438071.1350.43.camel@x61.thuisdomein>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 13 May 2013 15:27:15 +0530
Message-ID: <CA+V-a8sEMsQENPN+40bMtOpTs5Xq9HbtiR49shhd=+kXU3-2YA@mail.gmail.com>
Subject: Re: [v3] media: davinci: kconfig: fix incorrect selects
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Mon, May 13, 2013 at 3:11 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2013-03-12 at 09:14 +0000, Sekhar Nori wrote:
[Snip]
>> This patch has only been build tested; I have tried to not break
>> any existing assumptions. I do not have the setup to test video,
>> so any test reports welcome.
>>
>> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> This seems to be the patch that ended up as mainline commit
> 3778d05036cc7ddd983ae2451da579af00acdac2 (which was included in
> v3.10-rc1).
>
> After that commit there's still one reference to VIDEO_VPFE_CAPTURE in
> the tree: as a (negative) dependency in
> drivers/staging/media/davinci_vpfe/Kconfig. Can that (negative)
> dependency now be dropped (as it's currently useless) or should it be
> replaced with a (negative) dependency on a related symbol?
>
Good catch! the dependency can be dropped now. Are you planning to post a
patch for it or shall I do it ?

Regards,
--Prabhakar Lad
