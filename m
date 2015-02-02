Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60955 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbbBBS27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 13:28:59 -0500
Received: by mail-wi0-f176.google.com with SMTP id bs8so18961174wib.3
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2015 10:28:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54CFBA0E.205@openmailbox.org>
References: <54CFBA0E.205@openmailbox.org>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 2 Feb 2015 18:28:27 +0000
Message-ID: <CA+V-a8sGs-UM+_KHLwKq3f3RwcTSY8BaTvxtcOFheejn9KGU5A@mail.gmail.com>
Subject: Re: libv4l
To: Kyle Dominguez <kpd@openmailbox.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Feb 2, 2015 at 5:55 PM, Kyle Dominguez <kpd@openmailbox.org> wrote:
> Hello,
>
> When trying to build libv4l, it fails because I don't have the dependencies
> for v4l1. Is it possibe to make libv4l without having videodev.h? I only
> want the v4l2 parts, to which I have videodev2.h.
>
What are the steps you are following to build it ? What error do you get ?

just incase here are the correct steps (of current master assuming you
are cross compiling):
1: ./bootstrap.sh
2: ./configure  --host=<cross-compiler> --without-jpeg
3: make -j 4

Regards,
--Prabhakar Lad
