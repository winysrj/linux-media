Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54988 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2EJOjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 10:39:07 -0400
Received: by qcro28 with SMTP id o28so1156393qcr.19
        for <linux-media@vger.kernel.org>; Thu, 10 May 2012 07:39:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FABCD4B.1050803@redhat.com>
References: <4FA91BBF.5060405@iki.fi>
	<4FABCD4B.1050803@redhat.com>
Date: Thu, 10 May 2012 10:39:06 -0400
Message-ID: <CAGoCfiytCkzcTsDuSFkAqFw02rNkBFQB+Eq6AyPeB81RowXrmw@mail.gmail.com>
Subject: Re: [RFCv1] DVB-USB improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 10, 2012 at 10:14 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> In order to add analog support, it is likely simpler to take em28xx (mainly em28xx-video) as an
> example on how things are implemented on analog side. The gspca implementation may also help a
> lot, but it doesn't contain the tuner bits.

Antti,

If you do decide to take on analog in dvb-usb and use em28xx as a
model, bear in mind that the locking between analog and digital is
*totally* broken.  You can open both the analog and digital devices
simultaneously, causing completely unpredictable behavior.  I'm just
mentioning this because this is something you should *not* model after
em28xx, and because it's a huge headache for real users (lack of
locking causes all sorts of end-user problems in MythTV and other
applications that support both analog and digital).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
