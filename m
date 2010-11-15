Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57007 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab0KOCav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 21:30:51 -0500
Received: by mail-qw0-f46.google.com with SMTP id 4so123404qwi.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 18:30:50 -0800 (PST)
Subject: Re: [PATCH 3/3] [media] rc: Remove ir-common module
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101113173319.53942066@pedra>
Date: Sun, 14 Nov 2010 21:30:49 -0500
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <9F650ECB-29D3-48A4-A436-7FF79864238E@wilsonet.com>
References: <cover.1289676395.git.mchehab@redhat.com> <20101113173319.53942066@pedra>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Nov 13, 2010, at 2:33 PM, Mauro Carvalho Chehab wrote:

> Now, just one old bttv board uses the old RC5 raw decoding routines.
> Its conversion to rc-core requires the generation of IRQ data for both
> positive and negative transitions at the IRQ line. I'm not sure if
> bttv driver supports it or if the transitions will be reliable enough.
> So, due to the lack of hardware for testing, the better for now is to
> just move the legacy routines to bttv driver, and wait for someone with
> a Nebula Digi could help to port it to use also rc-core raw decoders.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



