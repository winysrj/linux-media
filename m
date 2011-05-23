Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59087 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1EWHBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 03:01:09 -0400
Received: by iyb14 with SMTP id 14so4416934iyb.19
        for <linux-media@vger.kernel.org>; Mon, 23 May 2011 00:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DDCBBAA2-C49C-4952-9D1B-519D8A3AB41E@beagleboard.org>
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com>
	<1305899272-31839-2-git-send-email-javier.martin@vista-silicon.com>
	<DDCBBAA2-C49C-4952-9D1B-519D8A3AB41E@beagleboard.org>
Date: Mon, 23 May 2011 09:01:07 +0200
Message-ID: <BANLkTi=ZHyk1+otf2i0qp47Zvvo4nfYk6A@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH v2 2/2] OMAP3BEAGLE: Add support for mt9p031
 sensor driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Koen Kooi <koen@beagleboard.org>
Cc: "beagleboard@googlegroups.com Board" <beagleboard@googlegroups.com>,
	Jason Kridner <jkridner@beagleboard.org>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, carlighting@yahoo.co.nz,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 20 May 2011 17:57, Koen Kooi <koen@beagleboard.org> wrote:
> In previous patch sets we put that in a seperate file (omap3beagle-camera.c) so we don't clutter up the board file with all the different sensor drivers. Would it make sense to do the same with the current patches? It looks like MCF cuts down a lot on the boilerplace needed already.

I sent my first patch using that approach but I was told to move it to
the board code.
Please, don't make undo the changes. Or at least, let's discuss this
seriously so that we all agree on what is the best way of doing it and
I don't have to change it every time.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
