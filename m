Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38830 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0IQPI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 11:08:59 -0400
Received: by yxp4 with SMTP id 4so763700yxp.19
        for <linux-media@vger.kernel.org>; Fri, 17 Sep 2010 08:08:58 -0700 (PDT)
Message-ID: <4C938484.3050606@gmail.com>
Date: Fri, 17 Sep 2010 12:08:52 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	"Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Trouble building v4l-dvb
References: <1284493110.1801.57.camel@sofia>	<4C924EB8.9070500@hoogenraad.net>	<4C93364C.3040606@hoogenraad.net>	<4C934806.7050503@gmail.com>	<4C934C10.2060801@hoogenraad.net>	<4C93800B.8070902@gmail.com> <AANLkTi=bs0qReM=+h-8eH=rx_AJkyUOWnZy4tarMbNbe@mail.gmail.com>
In-Reply-To: <AANLkTi=bs0qReM=+h-8eH=rx_AJkyUOWnZy4tarMbNbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-09-2010 12:00, Devin Heitmueller escreveu:
> On Fri, Sep 17, 2010 at 10:49 AM, Mauro Carvalho Chehab
> <maurochehab@gmail.com> wrote:
>> While you're there, the better is to also disable CONFIG_ALSA on Ubuntu, as the drivers
>> won't work anyway.
> 
> Note: while building ALSA modules did fail in some versions for
> Ubuntu, it has been over a years since I've seen that problem.
> Blindly disabling ALSA for all Ubuntu users would be a huge regression
> for users.

Yeah, blindly disabling it, if some versions work is not the right thing to do.

I'm not an Ubuntu user, so, I'm not sure when it was fixed. Still, from time to time,
people complain to me about this problem with some Ubuntu versions. The last complains I
heard were with some netbook versions of Ubuntu-based distros.

If there's a way to check what versions have broken alsa headers, then the checker should
just disable to the broken ones. Otherwise, the better way seems to just print a warning
message that ALSA might not be working, but keep it enabled.

Cheers,
Mauro
