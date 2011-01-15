Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50279 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1AORhl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 12:37:41 -0500
Received: by wwa36 with SMTP id 36so4105519wwa.1
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 09:37:37 -0800 (PST)
From: Albin Kauffmann <albin.kauffmann@gmail.com>
To: mmanzato <michele.manzato@gmail.com>
Subject: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
Date: Sat, 15 Jan 2011 18:37:28 +0100
Cc: linux-media@vger.kernel.org
References: <259225.84971.qm@web25402.mail.ukl.yahoo.com> <201010241627.22121.albin.kauffmann@gmail.com> <loom.20110111T145340-757@post.gmane.org>
In-Reply-To: <loom.20110111T145340-757@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101151837.28758.albin.kauffmann@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 11 January 2011 14:57:43 mmanzato wrote:
> Same behaviour here. I'm with Mythbuntu 10.10.
> 
> TDA10048 firwmare is found in the linux-firmware-nonfree Ubuntu package.
> From what I can see in dmesg it is loaded correctly.
> 
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1120 says that
> support for this card seems to be broken in recent Linux kernels (does
> that mean in recent V4L drivers?)

Yes. As far as I understand, Linux releases include a stable snapshot of V4L 
and both seem broken :(

-- 
Albin Kauffmann
Open Wide - Architecte Open Source
