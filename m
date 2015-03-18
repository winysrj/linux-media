Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:36806 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbbCRQ7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 12:59:10 -0400
Received: by qcto4 with SMTP id o4so43654452qct.3
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 09:59:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55073598.9010803@xs4all.nl>
References: <5507177A.8060200@parrot.com>
	<CAGoCfiyZt990gWqSPgaNE7L1fw=XN1DJiiQeDKvepO1Yz9cvaA@mail.gmail.com>
	<55073598.9010803@xs4all.nl>
Date: Wed, 18 Mar 2015 12:59:09 -0400
Message-ID: <CAGoCfiyrurHuigP3n=C_4gDpzJ4mSdU1di+AXsQdtVRzVEviow@mail.gmail.com>
Subject: Re: Dynamic video input/output list
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: =?UTF-8?Q?Aur=C3=A9lien_Zanelli?= <aurelien.zanelli@parrot.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Note however that it is perfectly fine if the driver detects the presence
> of such an onboard header when it is loaded and then only exposes those
> extra inputs if the header is present. It just can't change the list later
> unless do you an rmmod and modprobe of the driver. It's probably what you
> do anyway.

Ah, good point.  In my case I was working with PCIe cards where I had
no expectation that the cable was plugged/unplugged at runtime.

Sorry for the noise.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
