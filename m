Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39598 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280Ab2EETZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 15:25:07 -0400
Received: by lahj13 with SMTP id j13so2696392lah.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 12:25:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 6 May 2012 01:25:05 +0600
Message-ID: <CAFDqYy0E6qJncVxdN8sbhAH8=VsSumf_eJGOLYqzWR56jZN0Vw@mail.gmail.com>
Subject: staging/media/as102: Else statements in as10x_cmd.c
From: joseph daniel <josephdanielwalter@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

There are lots of places where if the xfer_cmd ptr is null we are
assiging error to AS10X_CMD_ERROR. actually we can do it at the
intialisation of error.

if you people think its correct, i can submit a change to you people.

Thanks,
