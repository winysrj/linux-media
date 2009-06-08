Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:29898 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZFHB3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 21:29:03 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1156894wfd.4
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2009 18:29:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244424059.3144.14.camel@palomino.walls.org>
References: <ab60605f580782732ecd676ecbab3ea3.squirrel@mail.voxel.net>
	 <829197380906071812m591c3c3dy2cdac036d116a574@mail.gmail.com>
	 <1244424059.3144.14.camel@palomino.walls.org>
Date: Sun, 7 Jun 2009 21:29:05 -0400
Message-ID: <829197380906071829r4132690ao965d88d589c65e5a@mail.gmail.com>
Subject: Re: funny colors from XC5000 on big endian systems
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: "W. Michael Petullo" <mike@flyn.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 7, 2009 at 9:20 PM, Andy Walls<awalls@radix.net> wrote:
> You may also want to check if CVBS or S-Video also shows the problem.  A
> simple test that will conclusively eliminate the XC5000.
>
> Regards,
> Andy

Well, it won't really be conclusive in this case - it's an
intermittent bug in the hardware, and is much more likely to occur
with the xc5000 because it happens when the signal needs to resync
(the 16-bit YUYV byte pair sometimes is read on the wrong boundary).
Hence it tends to occur more often with the xc5000 because of changing
channels (but can occur on the CVBS or S-Video inputs as well).  The
au0828 driver has code to detect this condition but there might be an
issue with the check.

Once I know the answer to the questions posed to Mike, I can work with
him to debug the issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
