Return-path: <linux-media-owner@vger.kernel.org>
Received: from xylos.xylon.de ([80.237.242.185]:58986 "EHLO mail.xylon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751166Ab0GYH6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 03:58:31 -0400
Received: from localhost (xylos.xylon.de [127.0.0.1])
	by mail.xylon.de (Postfix) with ESMTP id 725E16A0008
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 09:52:36 +0200 (CEST)
Received: from mail.xylon.de ([127.0.0.1])
	by localhost (mail.xylon.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8z0qlwLkhOZn for <linux-media@vger.kernel.org>;
	Sun, 25 Jul 2010 09:52:35 +0200 (CEST)
Message-ID: <20100725095235.20186r5nd8w29w74@webmail.xylon.de>
Date: Sun, 25 Jul 2010 09:52:35 +0200
From: Arnuschky <arnuschky@xylon.de>
To: linux-media@vger.kernel.org
Subject: Very poor (signal?) quality on buget card TwinHan VP DST
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using a TwinHan VP DST card under Ubuntu Lucid Lynx (2.6.32-23  
with s2-liplianin-dkms updated dvb drivers).

The card is detected fine, but does not seem to have analogue tuner. I  
can scan channels, and I can watch TV using digital-only capable  
applications (eg, Me-TV, Kaffeine). Nevertheless, the general picture  
quality is VERY bad. Basically, there's not a single frame without  
decoding error and freezes. Sound suffers the same problem. It all  
behaves like a bad signal/bad antenna installation.

The problem is: a parallel windows installation gives a crystal-clear  
and stable picture, without touching the antenna in between.

I assume it's a problem with channel fine-tuning or software decoder  
quality. Can anyone help me with solving these problems?

Thanks
Arne


