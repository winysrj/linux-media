Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52405 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab0IQPAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 11:00:32 -0400
Received: by ewy23 with SMTP id 23so1016309ewy.19
        for <linux-media@vger.kernel.org>; Fri, 17 Sep 2010 08:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C93800B.8070902@gmail.com>
References: <1284493110.1801.57.camel@sofia>
	<4C924EB8.9070500@hoogenraad.net>
	<4C93364C.3040606@hoogenraad.net>
	<4C934806.7050503@gmail.com>
	<4C934C10.2060801@hoogenraad.net>
	<4C93800B.8070902@gmail.com>
Date: Fri, 17 Sep 2010 11:00:31 -0400
Message-ID: <AANLkTi=bs0qReM=+h-8eH=rx_AJkyUOWnZy4tarMbNbe@mail.gmail.com>
Subject: Re: Trouble building v4l-dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	"Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Sep 17, 2010 at 10:49 AM, Mauro Carvalho Chehab
<maurochehab@gmail.com> wrote:
> While you're there, the better is to also disable CONFIG_ALSA on Ubuntu, as the drivers
> won't work anyway.

Note: while building ALSA modules did fail in some versions for
Ubuntu, it has been over a years since I've seen that problem.
Blindly disabling ALSA for all Ubuntu users would be a huge regression
for users.

> As we don't want to have complains from users about "why driver foo is not compiling for me",
> IMO, it should be printing a warning message saying that compilation of ALSA/FIREWIRE drivers with
> that specific kernel version is not possible, due to the back packaging of kernel headers,
> recommending to the user to get a vanilla upstream kernel, if he needs one of the disabled
> drivers.

I agree with this premise for firedtv, but see my comment above about ALSA.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
