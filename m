Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45137 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2INQeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 12:34:09 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 13:34:08 -0300
Message-ID: <CAH0vN5KeV6HquKG2GVuzMWXaDXJ1mhQwKuedRg-B24kiT-tEfg@mail.gmail.com>
Subject: Verify Seek Complete
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi media guys,

I'm trying to test a radio driver that is not in the mainline(yet),
and for it I'm making an application for the radio(because threre is
not radio app for that device).

Ad I have a doubt about the v4l2 seek: In the v4l2 framework, the
driver should wait for the seek complete, or the framework don't want
the driver do it?
Or the app layer needs to handle this?

Thanks since now!

-- 
Att,

Marcos Paulo de Souza
Acad�mico de Ciencia da Computa��o - FURB - SC
"Uma vida sem desafios � uma vida sem raz�o"
"A life without challenges, is a non reason life"
