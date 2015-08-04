Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34476 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbHDPnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 11:43:14 -0400
Received: by labow3 with SMTP id ow3so10199751lab.1
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2015 08:43:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DUB128-W255CECEF72511B6BBD79E19C770@phx.gbl>
References: <DUB128-W255CECEF72511B6BBD79E19C770@phx.gbl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 4 Aug 2015 16:42:43 +0100
Message-ID: <CA+V-a8s=d4HOvkYc2iqG3b+ouBjytqPrUmxeXTcigKWMn9cqCg@mail.gmail.com>
Subject: Re: drivers/media/platform/am437x/am437x-vpfe.c:1698: bad test ?
To: David Binderman <dcb314@hotmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

On Mon, Aug 3, 2015 at 3:02 PM, David Binderman <dcb314@hotmail.com> wrote:
> Hello there,
>
> drivers/media/platform/am437x/am437x-vpfe.c:1698:27: warning: self-comparison always evaluates to true [-Wtautological-compare]
>
>      if (client->addr == curr_client->addr &&
>             client->adapter->nr == client->adapter->nr) {
>
> maybe
>
>      if (client->addr == curr_client->addr &&
>             client->adapter->nr == curr_client->adapter->nr) {
>
Good catch!
I'll post a patch fixing it.

Cheers,
--Prabhakar Lad
