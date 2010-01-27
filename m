Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:34540 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab0A0TdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 14:33:12 -0500
Message-ID: <4B6094DE.4000204@arcor.de>
Date: Wed, 27 Jan 2010 20:32:46 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
References: <4B547EBF.6080105@arcor.de> <4B5DAC3A.6000408@redhat.com> <4B5DC2EA.3090706@arcor.de> <4B5DF134.7080603@redhat.com> <4B5DF360.40808@arcor.de> <4B5DF73F.9030807@redhat.com> <4B5E06EA.40204@arcor.de> <4B6093E4.40706@arcor.de>
In-Reply-To: <4B6093E4.40706@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a problem with usb bulk transfer. After a while, as I scan digital channel (it found a few channel), it wrote this in the log:

Jan 26 21:58:35 linux-v5dy kernel: [  548.756585] tm6000: status != 0

I updated the tm6000_urb_received function so that I can read the Error code and it logged:

Jan 27 17:41:28 linux-v5dy kernel: [ 3121.892793] tm6000: status = 0xffffffb5

Can you help me? Who I can calculate urb size?

Cheers

Stefan Ringel


-- 

Stefan Ringel <stefan.ringel@arcor.de>

