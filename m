Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57007 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab0KOCbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 21:31:05 -0500
Received: by mail-qw0-f46.google.com with SMTP id 4so123404qwi.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 18:31:04 -0800 (PST)
Subject: Re: [PATCH 2/3] [media] saa7134: Remove legacy IR decoding logic inside the module
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101113173316.76e5a56d@pedra>
Date: Sun, 14 Nov 2010 21:31:02 -0500
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <54797F1B-5200-4CA1-BA04-2B5A62CFC119@wilsonet.com>
References: <cover.1289676395.git.mchehab@redhat.com> <20101113173316.76e5a56d@pedra>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Nov 13, 2010, at 2:33 PM, Mauro Carvalho Chehab wrote:

> The only IR left still using the old raw decoders on saa7134 is ENCORE
> FM 5.3. As it is now using the standard rc-core raw decoders, lots
> of old code can be removed from saa7134.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



