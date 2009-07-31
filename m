Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63145 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZGaTuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 15:50:24 -0400
Received: by bwz19 with SMTP id 19so1382312bwz.37
        for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 12:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A734A40.7040306@magic.ms>
References: <4A61FD76.8010409@magic.ms> <4A733BAB.6080305@magic.ms>
	 <4A734A40.7040306@magic.ms>
Date: Fri, 31 Jul 2009 21:50:24 +0200
Message-ID: <d9def9db0907311250r8507a38n1f703b7f74cd7b26@mail.gmail.com>
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
From: Markus Rechberger <mrechberger@gmail.com>
To: emagick@magic.ms
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 31, 2009 at 9:47 PM, <emagick@magic.ms> wrote:
> Apparently, usb_bulk_msg() cannot be used with data on the stack:
>
> http://www.linuxtv.org/pipermail/linux-dvb/2008-August/028150.html
> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg19158.html
> --

As far as I recall this has been documented for ages already...
Although many people stumble over it... last but not least there's no reason to
have USB drivers in the kernel anyway..

Markus
