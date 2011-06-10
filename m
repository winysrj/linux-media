Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52186 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1FJNSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 09:18:08 -0400
Received: by eyx24 with SMTP id 24so895134eyx.19
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 06:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF0C5AB.5040304@linuxtv.org>
References: <cover.1307563765.git.mchehab@redhat.com>
	<20110608172302.3e2294af@pedra>
	<4DF0C015.1090807@linuxtv.org>
	<4DF0C4E1.1020406@redhat.com>
	<4DF0C5AB.5040304@linuxtv.org>
Date: Fri, 10 Jun 2011 09:18:07 -0400
Message-ID: <BANLkTi=FswJcBLH6=SMsqdmy8vk214pqiA@mail.gmail.com>
Subject: Re: [PATCH 05/13] [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 9, 2011 at 9:07 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
> ... implemented in *kernel* drivers for several generations of the dreambox.

Well, let's see the source code to the drivers in question, and from
there we can make some decisions on how to best proceed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
