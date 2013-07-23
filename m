Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63573 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934466Ab3GWW5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 18:57:04 -0400
Received: by mail-ob0-f171.google.com with SMTP id dn14so11537221obc.16
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 15:57:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9+KX2G8bz_9gpwBJpUr14VBUo=qAYLHm9-_0b8z_XUdzQ@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
	<CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
	<CAA9z4LYFW4iZsQgbPHHhy1ESiEDtVyNV4QaSeULq7p+kWs+e=A@mail.gmail.com>
	<CAHFNz9KNMVXa1kpMjoiiB4T9P-=AQqm7cfPDau_mtAQTxbUCEw@mail.gmail.com>
	<CAA9z4LbeV223oPfyjzUpGLrg55Z8Eag8Hpu3x++N_LsiRr8y+Q@mail.gmail.com>
	<CAHFNz9+KX2G8bz_9gpwBJpUr14VBUo=qAYLHm9-_0b8z_XUdzQ@mail.gmail.com>
Date: Tue, 23 Jul 2013 16:57:02 -0600
Message-ID: <CAA9z4Lb_43u28qF+u445B2FqYHufK4yR6vWpxp9wKDvRezqeTg@mail.gmail.com>
Subject: Re: Proposed modifications to dvb_frontend_ops
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problems isnt for tuners where FEC_AUTO does work, its more for
ones that dont work like the genpix. Im sure there are others too. I
still think that userland applications should be able to poll that
info and that the ability to poll the info is a good thing not a bad
thing.

oh well, lets let this patch die, and the idea can be revisited in the
future if it warrants more of a pressing need.

Chris
