Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2IZNAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 09:00:40 -0400
Received: by wibhq12 with SMTP id hq12so4892708wib.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 06:00:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Date: Wed, 26 Sep 2012 15:00:39 +0200
Message-ID: <CACKLOr39ObYOxy1DJuO5Lp5AwK6zc_HFiHHdV1tHEqYjeb8PfQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] media: ov7670: driver cleanup and support for ov7674.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 September 2012 11:47, Javier Martin
<javier.martin@vista-silicon.com> wrote:
> The following series includes all the changes discussed in [1] that
> don't affect either bridge drivers that use ov7670 or soc-camera framework
> For this reason they are considered non controversial and sent separately.
> At least 1 more series will follow in order to implement all features
> described in [1].
>
>
>
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg51778.html

Support is for ov7675, not ov7674, sorry for the typo.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
