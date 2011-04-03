Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40721 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1DCPov (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 11:44:51 -0400
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: Re: [PATCH] [media] dib0700: fix possible NULL pointer dereference
Date: Sun, 3 Apr 2011 17:44:40 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	Wolfram Sang <w.sang@pengutronix.de>,
	David =?iso-8859-1?q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1301163836-7601-1-git-send-email-mk@lab.zgora.pl>
In-Reply-To: <1301163836-7601-1-git-send-email-mk@lab.zgora.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104031744.41141.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 26 March 2011 19:23:56 Mariusz Kozlowski wrote:
> Seems like 'adap->fe' test for NULL was meant to be before we dereference
> that pointer.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Thanks, applied.

--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
