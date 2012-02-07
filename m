Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53614 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2BGQxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 11:53:38 -0500
Received: by vbjk17 with SMTP id k17so4742341vbj.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 08:53:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F314AE7.90308@gmail.com>
References: <4F2AC7BF.4040006@ukfsn.org>
	<4F2ADDCB.4060200@gmail.com>
	<CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>
	<4F2B16DF.3040400@gmail.com>
	<CAGoCfiybOLL2Owz2KaPG2AuMueHYKmN18A8tQ7WXVkhTuRobZQ@mail.gmail.com>
	<4F310091.80107@gmail.com>
	<CAGoCfiwXj58Men1Yi3OoH7CYAbiB7-KXs9fV8QkEnn3Y8Qe=sw@mail.gmail.com>
	<4F314AE7.90308@gmail.com>
Date: Tue, 7 Feb 2012 11:53:36 -0500
Message-ID: <CAGoCfiyBh6zsaQYtuBURGfaKzt4mJvLrC-G5DeEAurP2n1P=PQ@mail.gmail.com>
Subject: Re: PCTV 290e page allocation failure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: gennarone@gmail.com
Cc: Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 7, 2012 at 11:01 AM, Gianluca Gennari <gennarone@gmail.com> wrote:
> Please note that the buffer size and the buffer allocation strategy (at
> runtime or at driver initialization) are two completely different
> topics. The first can cause regressions, the second should not produce
> any functional change (bugs excluded).

Agreed.  I would break this into two patches and submit the buffer
allocation strategy change first.  I think that should be able to go
upstream without too much debate/discussion.  From there we can
discuss the merits of the various approaches for the second patch
(relating to the buffer size).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
