Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2E1JBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 05:01:34 -0400
Received: by obbtb18 with SMTP id tb18so5100631obb.19
        for <linux-media@vger.kernel.org>; Mon, 28 May 2012 02:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337608600.10262.8.camel@deadeye>
References: <1337608600.10262.8.camel@deadeye>
Date: Mon, 28 May 2012 17:01:34 +0800
Message-ID: <CAHG8p1ApwjfXGmXcUrzyk2tFUcxak2kah_jy+Mv+jqeFOWwTFA@mail.gmail.com>
Subject: Re: Firmware blob in vs6624 driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

> This doesn't touch any of the documented registers, so presumably it's a
> patch to the firmware loaded from non-volatile memory.  Unless you can
> provide source code for the patch, this should go in the linux-firmware
> repository and be loaded with request_firmware() instead of embedded in
> the GPL driver source.
Sounds reasonable.
>
> Also, shouldn't you check the loaded firmware version first to verify
> that it's safe to apply the patch?
The problem is you can't get version before power up device but you
should apply patch at that time.

Scott
