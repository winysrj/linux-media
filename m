Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:43314 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaKQQKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 11:10:15 -0500
Received: by mail-yk0-f178.google.com with SMTP id 20so3084786yks.9
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 08:10:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA++x_yD6oxb4mkbP_8UtHU13LM5dgacbtHXWKe+qpDEfFp5bMw@mail.gmail.com>
References: <CA++x_yD6oxb4mkbP_8UtHU13LM5dgacbtHXWKe+qpDEfFp5bMw@mail.gmail.com>
Date: Mon, 17 Nov 2014 17:10:14 +0100
Message-ID: <CA++x_yB3PA=gsFO-Lbhvn7ayUjUDdVJfmkLKqTOn1H14-ytmPQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
From: Michael Holzer <michael.w.holzer@gmail.com>
To: "olli.salonen" <olli.salonen@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

re ' we start to have quite a list of chips there in the printouts
(Si2147/Si2148/Si2157/Si2158) and
more is coming -...
Should we just say "Si214x/Si215x" there or something?'

I'd see merit to show the supported chips explicitly as otherwise users
may be confused if a new unsupported chip  (lets assume Si2159)
appears and the message is generic as proposed "Si215x".
To get clarity for this case source code reading would be required.
 just my 5 cent ;-)
Mike
