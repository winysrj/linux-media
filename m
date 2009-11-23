Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48171 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZKWPUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 10:20:50 -0500
MIME-Version: 1.0
In-Reply-To: <m36391tjj3.fsf@intrepid.localdomain>
References: <200910200956.33391.jarod@redhat.com>
	 <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	 <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
Date: Mon, 23 Nov 2009 10:20:54 -0500
Message-ID: <829197380911230720k233c3c86t659180d1413aa0dd@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 9:14 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> I think this makes a lot of sense.
> But: we don't need a database of RC codes in the kernel (that's a lot of
> data, the user has to select the RC in use anyway so he/she can simply
> provide mapping e.g. RC5<>keycode).

Just bear in mind that with the current in-kernel code, users do *not
* have to manually select the RC code to use if they are using the
default remote that shipped with the product.  This helps alot for
those unfamiliar with LIRC, since their product "works out of the box"
with the remote the product came with.  I agree though, that the user
should be able to easily change the RC to be used if he/she decides to
use a remote other than the default.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
