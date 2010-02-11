Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f190.google.com ([209.85.221.190]:53252 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0BKMix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 07:38:53 -0500
Received: by qyk28 with SMTP id 28so692396qyk.25
        for <linux-media@vger.kernel.org>; Thu, 11 Feb 2010 04:38:52 -0800 (PST)
Message-ID: <4B73FA56.5010107@gmail.com>
Date: Thu, 11 Feb 2010 10:38:46 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Franklin Meng <fmeng2002@yahoo.com>
CC: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>
Subject: Re: [Patch/Resend] Kworld 315U remote support
References: <251005.1068.qm@web32708.mail.mud.yahoo.com>
In-Reply-To: <251005.1068.qm@web32708.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Subject: Re: [Patch/Resend] Kworld 315U remote support

Well, it is not a resend, since changes were made ;)

Franklin Meng wrote:

> +static struct ir_scancode ir_codes_kworld_315u[] = {
> +    { 0x6143, KEY_POWER },

Please, never indent with spaces. Instead, you should use tabs, and a tab=8 spaces.

I fixed it and applied the patch.

-- 

Cheers,
Mauro
