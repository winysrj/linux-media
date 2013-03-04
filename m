Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64303 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab3CDVeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 16:34:15 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so4145568eek.1
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 13:34:14 -0800 (PST)
Message-ID: <51351387.2000600@googlemail.com>
Date: Mon, 04 Mar 2013 22:35:03 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] em28xx: add support for em25xx i2c bus B read/write/check
 device operations
References: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com> <1362339661-3446-2-git-send-email-fschaefer.oss@googlemail.com> <20130304172005.58590d43@redhat.com> <20130304172341.630de7e6@redhat.com> <513512A6.1020605@googlemail.com>
In-Reply-To: <513512A6.1020605@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.03.2013 22:31, schrieb Frank Schäfer:

> ...
> I don't expect this chip to appear in one of the devices with the
> currently supported generic IDs.

Hmm... maybe I should add:
it doesn't make sense to add the generic USB ID of this chip (eb1a:2765)
to the driver, because most of the devices using it should be UVC compliant.
The same should apply to all other newer Empia camera bridges
(EM276x/7x/8x).

Regards,
Frank


