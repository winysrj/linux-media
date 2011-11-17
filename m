Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1KQV6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 16:58:38 -0500
Received: by yenq3 with SMTP id q3so1692679yen.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 13:58:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ja3vrr$27b$1@dough.gmane.org>
References: <ja3vrr$27b$1@dough.gmane.org>
Date: Thu, 17 Nov 2011 16:58:37 -0500
Message-ID: <CAGoCfiz6K-8q3zCRWPhAWtxzJyJ_DVvEXu8PR2-A2ER=XqYj6A@mail.gmail.com>
Subject: Re: "scan" returns channels with no VID
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2011 at 4:55 PM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> Hi.
>
> Using dvb-apps 1.1.1+rev1355-1ubuntu1 on Ubuntu, I'm scanning my qam
> channels with "scan" on both an Hauppage HVR-950q and HVR-1600 and the
> resulting output contains channels which I know are both audio and video
> yet the VID field of the output is 0.  i.e.
>
> 120:585000000:QAM_256:0:5842:11
> 121:585000000:QAM_256:0:5846:77
> 122:585000000:QAM_256:0:5848:936
> 123:585000000:QAM_256:0:5850:958
>
> These are all viewable "channels".  Any ideas why the VID is empty?
>
> At the same time, other "channels" have a VID but are not actually
> viewable/tunable:
>
> 108:555000000:QAM_256:3691:3692:726
> 109:555000000:QAM_256:3695:3696:728
> 110:555000000:QAM_256:3693:3694:727
>
> Any ideas?

I'm not sure about the ones that don't have a VID, but the ones that
have a VID which aren't viewable are probably because they're
encrypted.  The /usr/bin/scan tool will return channels in the list
regardless of whether they can actually be viewed without a Cablecard.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
