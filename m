Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:44023 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161177AbaJ3UxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:53:00 -0400
Received: by mail-la0-f43.google.com with SMTP id ge10so5199940lab.30
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 13:52:59 -0700 (PDT)
Date: Thu, 30 Oct 2014 22:52:52 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Olli Salonen <olli.salonen@iki.fi>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: add support for TechnoTrend CT2-4500 CI
In-Reply-To: <1414702107-24963-1-git-send-email-olli.salonen@iki.fi>
Message-ID: <alpine.DEB.2.10.1410302249490.25005@dl160.lan>
References: <1414702107-24963-1-git-send-email-olli.salonen@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Oct 2014, Olli Salonen wrote:

> TechnoTrend CT2-4500 CI is a PCIe device with DVB-T2/C tuner. It is 
> similar to DVBSky T980C, just with different PCI ID and remote 
> controller.

Additional note, this should be applied on top of Max Nibble's commits:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg80865.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg80866.html

In patchwork they're 26538 and 26539.

Cheers,
-olli
