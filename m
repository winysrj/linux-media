Return-path: <mchehab@gaivota>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52406 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1EHLiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 07:38:13 -0400
Received: by qwk3 with SMTP id 3so2604242qwk.19
        for <linux-media@vger.kernel.org>; Sun, 08 May 2011 04:38:12 -0700 (PDT)
MIME-Version: 1.0
From: "Roman B." <rbyshko@gmail.com>
Date: Sun, 8 May 2011 13:37:52 +0200
Message-ID: <BANLkTinFCvSB5QOOq7bmuBDa65dnC0PNLA@mail.gmail.com>
Subject: gspca_zc3xx (HV7131R sensor) driver brocken
To: linux-media@vger.kernel.org, moinejf@free.fr
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Dear list, dear Jean-Francois,

since the upgrade of the kernel to 2.6.37.1 my webcamera (046d:08d7
Logitech, Inc. QuickCam Communicate STX) is brocken. The problem is
exactly the same as in this bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=24242 The problem of
contrast seems to dissapear in the new 2.6.39-rc4 kernel, but that
time the camera response is brocken. I'm not sure how to technically
describe it correctly. I think the fps is very slow, causing a slight
movement of the object create ugly picture where everything is
blurred. I would be very glad to get my camera back working, as it was
before. (I'm just wondering why should one change something at all...
)

I suppose the maintainer of the gspca driver is Jean-Francois Moine.
However he seems not to react to the bugs in bugzilla. The simple
search

https://bugzilla.kernel.org/buglist.cgi?quicksearch=QuickCam

gives a buch of bugs (of gspca) that hang there for months. That's why
prior to filing a bug there I decided to say about my issue here. At
least it will be heard...

Thank you and best regards,
Roman
