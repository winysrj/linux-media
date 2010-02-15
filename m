Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:38869 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab0BOWhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 17:37:13 -0500
Received: by fxm7 with SMTP id 7so6386124fxm.28
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 14:37:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381002151434r505adb48l8b45b4e87f0baaaa@mail.gmail.com>
References: <310bfb251002151257x7121b20cme3cbe5096decea4b@mail.gmail.com>
	 <a728f9f91002151421y6d2c0d2fgfc715517bf1d56e8@mail.gmail.com>
	 <829197381002151434r505adb48l8b45b4e87f0baaaa@mail.gmail.com>
Date: Mon, 15 Feb 2010 17:37:11 -0500
Message-ID: <a728f9f91002151437g45166a31x359bffda2bab6f98@mail.gmail.com>
Subject: Re: ATI TV Wonder 650 PCI development
From: Alex Deucher <alexdeucher@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Samuel Cantrell <samuelcantrell@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2010 at 5:34 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Feb 15, 2010 at 5:21 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> Who did you contact?   gpudriverdevsupport AT amd DOT com is the devel
>> address you probably want.  I looked into documentation for the newer
>> theatre chips when I started at AMD, but unfortunately, I'm not sure
>> how much we can release since we sold most of our multimedia IP to
>> Marvell last year.  I'm not sure what the status of the theatre chips
>> is now.
>>
>> Documentation for the older theatre and theatre 200 asics was released
>> under NDA years ago which resulted in the theatre support in the
>> opensource radeon Xorg driver and gatos projects.  Now that we a
>> proper KMS driver for radeon, someone could port the old userspace
>> theatre code to the kernel for proper v4l support on AIW radeon cards.
>>
>> Alex
>
> For what it's worth, I actually did have a contact at the ATI/AMD
> division that made the Theatre 312/314/316, and I was able to get
> access to both the docs and reference driver sources under NDA.
> However, the division in question was sold off to Broadcom, and I
> couldn't get the rights needed to do a GPL driver nor to get
> redistribution rights on the firmware.  In fact, they couldn't even
> told me who actually *held* the rights for the reference driver code.
>
> At that point, I decided that it just wasn't worth the effort for such
> an obscure design.

Ah right, I meant Broadcom, not Marvell.

Alex
