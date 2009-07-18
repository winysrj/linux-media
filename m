Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:32944 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZGRWNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 18:13:34 -0400
Received: by gxk9 with SMTP id 9so2802965gxk.13
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 15:13:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090718213428.GA8854@localhost.localdomain>
References: <20090718213428.GA8854@localhost.localdomain>
Date: Sat, 18 Jul 2009 18:13:30 -0400
Message-ID: <829197380907181513mbd8dc5ag7facc128a2b2a951@mail.gmail.com>
Subject: Re: [PATCH] em28xx: kworld 340u
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: acano@fastmail.fm
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 18, 2009 at 5:34 PM, <acano@fastmail.fm> wrote:
> support for kworld 340u.  8vsb and qam256 work, qam64 untested.
>
>

Hello Acano,

You should talk to Jarod Wilson about this.  He did a bunch of work to
get the 340u working over the last couple of months, and you two could
probably collaborate on a unified solution.  There were also some
problems related to the fact that the device can have either the
tda18271c1 or the c2 (both have the same USB id), which would have to
be accommodated in the final solution.

The patch itself also needs alot of cleanup and doesn't meet the
coding standards.  It would need considerable cleanup before it could
be taken upstream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
