Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53184 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3DMSk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 14:40:29 -0400
Received: by mail-ea0-f177.google.com with SMTP id q14so1616380eaj.36
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 11:40:27 -0700 (PDT)
Message-ID: <5169A6E0.8060902@googlemail.com>
Date: Sat, 13 Apr 2013 20:41:36 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com> <20130413114144.097a21a1@redhat.com> <51697AC8.1050807@googlemail.com> <20130413140444.2fba3e88@redhat.com> <516999EC.6080605@googlemail.com> <5169A19F.6080407@googlemail.com>
In-Reply-To: <5169A19F.6080407@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.04.2013 20:19, schrieb Frank Schäfer:
> Am 13.04.2013 19:46, schrieb Frank Schäfer:
>> ...
>> We always write to the GPIO register. That's why these functions are
>> called em28xx_write_* ;)
>> Whether the write operation is sane or not (e.g. because it modifies the
>> bit corresponding to an input line) is not subject of these functions.
> Hmm... that's actually not true for em28xx_write_regs().
> The current/old code never writes the value to GPIO registers, it just
> saves it to the device struct.

Arghh... no ... please disregard this paragraph, I simply overlooked the
register write.
I have to stop for today, will try to get back to this tomorrow.

Regards,
Frank

