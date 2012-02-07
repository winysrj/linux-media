Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50850 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765Ab2BGHrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Feb 2012 02:47:17 -0500
Received: by lagu2 with SMTP id u2so3781675lag.19
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 23:47:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vBpt1WqHxD2OqYTTfU7SFZ=1QQfqae3kpzu6U-opHEwg@mail.gmail.com>
References: <CA+V-a8vBpt1WqHxD2OqYTTfU7SFZ=1QQfqae3kpzu6U-opHEwg@mail.gmail.com>
Date: Tue, 7 Feb 2012 08:47:15 +0100
Message-ID: <CACKLOr045hbPspwbM_rONNOQhPv+v0Gn+zLXr=5jqKfXVO7__g@mail.gmail.com>
Subject: Re: videobuf2 porting
From: javier Martin <javier.martin@vista-silicon.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 7 February 2012 08:16, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> Hi folks,
>
> I was trying to port a existing driver to videobuf2 framework, I had a
> hurdle in between
> the driver I was trying to port supports user pointer, How does
> videobuf2 support this
> thing ?

If the driver you are trying to port supports old videobuf framework
this patch might be useful for you:

http://patchwork.linuxtv.org/patch/9719/

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
