Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward5m.mail.yandex.net ([37.140.138.5]:42587 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbaKTVRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 16:17:15 -0500
From: CrazyCat <crazycat69@yandex.ua>
To: Olli Salonen <olli.salonen@iki.fi>,
	Michael Holzer <michael.w.holzer@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1411202204550.1388@dl160.lan>
References: <CA++x_yD6oxb4mkbP_8UtHU13LM5dgacbtHXWKe+qpDEfFp5bMw@mail.gmail.com> <CA++x_yB3PA=gsFO-Lbhvn7ayUjUDdVJfmkLKqTOn1H14-ytmPQ@mail.gmail.com> <alpine.DEB.2.10.1411202204550.1388@dl160.lan>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
MIME-Version: 1.0
Message-Id: <1398851416517620@web24m.yandex.ru>
Date: Thu, 20 Nov 2014 23:07:00 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need, because si214x is same si215x without analog filter path.

20.11.2014, 22:10, "Olli Salonen" <olli.salonen@iki.fi>:
> Crazycat, do you think you could change the firmware loading for Si2148
> as discussed here though and send a new patch?
