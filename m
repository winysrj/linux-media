Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47482 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1DKJLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 05:11:07 -0400
Received: by iwn34 with SMTP id 34so5426782iwn.19
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 02:11:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104081907.02509.laurent.pinchart@ideasonboard.com>
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com>
	<201104081707.17576.laurent.pinchart@ideasonboard.com>
	<BANLkTi=NTHHyGRhCff+wvXWL4pD+Dv4b8w@mail.gmail.com>
	<201104081907.02509.laurent.pinchart@ideasonboard.com>
Date: Mon, 11 Apr 2011 11:11:06 +0200
Message-ID: <BANLkTikXGVLG6E9TeQc1PQjiybeZxrNYdw@mail.gmail.com>
Subject: Re: mt9t111 sensor on Beagleboard xM
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,

>
> Adding pad-level operations will not break any existing driver, as long as you
> keep the existing operations functional.
>

Is it really possible to have a sensor driver supporting soc-camera,
v4l2-subdev and pad-level operations?
I've been reviewing the code of mt9t112 and I'm not very sure
soc-camera code can be easily isolated.

What is the future of soc-camera anyway? Since it seems v4l2-subdev
and media-controller clearly make it deprecated.
Wouldn't it be more suitable to just develop a separate mt9t112 driver
which includes v4l2-subdev and pad-level operations without
soc-camera?

Thanks.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
