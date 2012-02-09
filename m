Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53506 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2BIQVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2012 11:21:39 -0500
Received: by eekc14 with SMTP id c14so640732eek.19
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2012 08:21:38 -0800 (PST)
Message-ID: <4F33F28F.3040704@gmail.com>
Date: Thu, 09 Feb 2012 17:21:35 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andrej Podzimek <andrej@podzimek.org>, linux-media@vger.kernel.org
Subject: Re: AverTV Volar HD PRO
References: <4F2F145C.6000405@podzimek.org> <4F2F3BE1.7030801@gmail.com> <4F30B22B.9050708@podzimek.org>
In-Reply-To: <4F30B22B.9050708@podzimek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 07/02/2012 06:10, Andrej Podzimek ha scritto:

> An attempt to scan channels in Kaffeine always fails before the progress
> bar reaches 20% and lots of messages like this appear in dmesg:
> 
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0045
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0048
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:002c
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0047
>     af9035: recv bulk message failed:-110
>     af9033: I2C read failed reg:0048

Hi Andrej,
I contacted the original creator of the patch that you used previously
(Xgaz on Ubuntu.it forums).

He passed this suggestion to me (coming from a Spanish user):


For people having the kernel message "af9035: recv bulk message
failed:-110", it's due a problem with the power save mode. To solve it,
create the file "/etc/modprobe.d/options.conf" with this content:

options dvb-core dvb_powerdown_on_sleep=0


So basically you may need to disable the power saving functionalities to
make the device working again.

Since the only functional difference between the old and the new patch
version is in the remote code (which I removed), probably this code was
preventing your device to go into sleep mode, so it was hotter but
worked fine.

Please report if this helps.

Regards,
Gianluca
