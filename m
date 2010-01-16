Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47451 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0APWZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 17:25:36 -0500
Received: by ewy19 with SMTP id 19so2059603ewy.21
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 14:25:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263678300-20313-1-git-send-email-ospite@studenti.unina.it>
References: <1263678300-20313-1-git-send-email-ospite@studenti.unina.it>
Date: Sat, 16 Jan 2010 17:25:34 -0500
Message-ID: <7b67a5ec1001161425ree6035cr665ab7727b68991e@mail.gmail.com>
Subject: Re: [PATCH] ov534: fix end of frame handling, make the camera work
	again.
From: Max Thrun <bear24rw@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Jim Paris <jim@jtan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch Antonio

I can confirm that this patch does fix the problem, definitely needs
to be merged asap as the webcam is unusable without.

- Max Thrun
