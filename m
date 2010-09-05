Return-path: <mchehab@localhost>
Received: from smtp5-g21.free.fr ([212.27.42.5]:50330 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab0IEI40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 04:56:26 -0400
Date: Sun, 5 Sep 2010 10:56:27 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
Message-ID: <20100905105627.0d5d3dab@tele>
In-Reply-To: <4C834D46.5030801@redhat.com>
References: <20100904131048.6ca207d1@tele>
	<4C834D46.5030801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, 05 Sep 2010 09:56:54 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> I think that using one control for both status leds (which is what we
> are usually talking about) and illuminator(s) is a bad idea. I'm fine
> with standardizing these, but can we please have 2 CID's one for
> status lights and one for the led. Esp, as I can easily see us
> supporting a microscope in the future where the microscope itself or
> other devices with the same bridge will have a status led, so then we
> will need 2 separate controls anyways.

Hi Hans,

I was not thinking about the status light (I do not see any other usage
for it), but well about illuminators which I saw only in microscopes.

So, which is the better name? V4L2_CID_LAMPS? V4L2_CID_ILLUMINATORS?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
