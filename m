Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36314 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZLIRSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 12:18:40 -0500
Received: by fxm5 with SMTP id 5so7781502fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 09:18:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912090914o5e80c6fwa877ccb9580bc6d9@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	 <59cf47a80912090806j7f75c578g1fa5a638b2fd7c39@mail.gmail.com>
	 <ad6681df0912090823s23c3dd11xe7b56b66803720d7@mail.gmail.com>
	 <59cf47a80912090838h61deade9y5bbf846e92027c85@mail.gmail.com>
	 <ad6681df0912090914o5e80c6fwa877ccb9580bc6d9@mail.gmail.com>
Date: Wed, 9 Dec 2009 12:18:45 -0500
Message-ID: <829197380912090918n32ea33eq2658ea57b27dedaa@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Paulo Assis <pj.assis@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 9, 2009 at 12:14 PM, Valerio Bontempi
> Hi Paulo,
>
> no luck with your suggestion, I have no errors compiling and
> installing the drivers but after rebooting it is not working at all.
> Modprobe em28xx produces the same error already sent in the previous mail

You're seeing an error when you modprobe?  What is the error?  Your
dmesg did not show any errors, just that the driver didn't load.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
