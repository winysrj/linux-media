Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41061 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaA0A2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 19:28:03 -0500
Received: by mail-vb0-f46.google.com with SMTP id o19so2962003vbm.5
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 16:28:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390781812-20226-1-git-send-email-crope@iki.fi>
References: <1390781812-20226-1-git-send-email-crope@iki.fi>
Date: Sun, 26 Jan 2014 19:28:01 -0500
Message-ID: <CAGoCfiyQ6-SA-5PYMgAv3Oq3gzcR-ReYCpL8Ak-KRVw0XHNd4Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] e4000: convert DVB tuner to I2C driver model
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 26, 2014 at 7:16 PM, Antti Palosaari <crope@iki.fi> wrote:
> Driver conversion from proprietary DVB tuner model to more
> general I2C driver model.

Mike should definitely weigh in on this.  Eliminating the existing
model of using dvb_attach() for tuners is something that needs to be
considered carefully, and this course of action should be agreed on by
the subsystem maintainers before we start converting drivers.  This
could be particularly relevant for hybrid tuners where the driver
instance is instantiated via tuner-core using dvb_attach() for the
analog side.

In the meantime, this change makes this driver work differently than
every other tuner in the tree.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
