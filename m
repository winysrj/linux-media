Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65384 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3GXQjC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 12:39:02 -0400
Received: by mail-ob0-f169.google.com with SMTP id up14so13703256obb.0
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 09:39:01 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Jul 2013 10:39:01 -0600
Message-ID: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com>
Subject: stv090x vs stv0900 support
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Im looking for comments on these two modules, they overlap support for
the same demods. stv0900 supporting stv0900 and stv090x supporting
stv0900 and stv0903. Ive flipped a few cards from one to the other and
they function fine. In some ways stv090x is better suited. Its a pain
supporting two modules that are written differently but do the same
thing, a fix in one almost always means it has to be implemented in
the other as well.

Im not necessarily suggesting dumping stv0900, but Id like to flip a
few cards that I own over to stv090x just to standardize it. The Prof
7301 and Prof 7500.

Whats everyones thoughts on this? It will cut the number of patch''s
in half when it comes to these demods. Ive got alot more coming lol :)

Chris
