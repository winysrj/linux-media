Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35709 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaCCErU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 23:47:20 -0500
Received: by mail-qa0-f52.google.com with SMTP id m5so3075579qaj.11
        for <linux-media@vger.kernel.org>; Sun, 02 Mar 2014 20:47:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <53137384.6080302@googlemail.com>
References: <CA+J5NAHzVvx47RcBrcTcZe8SfJ3wVP3jo3JhH5j68MaU+HZrXQ@mail.gmail.com>
	<53137384.6080302@googlemail.com>
Date: Sun, 2 Mar 2014 23:47:19 -0500
Message-ID: <CAGoCfizuN3pKUzQSvEVBg8=ONcoxoCOBY85w5N_WP8D08H7omQ@mail.gmail.com>
Subject: Re: Unknown EM2800 video grabber (card=0)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Jacob Korf <jacobkorf@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> No idea what's going wrong here, but this dmesg output is definitely
> incomplete.
> Or maybe you modifed the driver and messed things up ? ;-)

My guess is that it's not actually an em28xx device at all (and the
doc the user is referring to refers to some device by the manufacturer
with the same name).

Open it up and send us some hi-res photos of the PCB.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
