Return-path: <linux-media-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:49529 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433Ab0BUL3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 06:29:35 -0500
From: Frans Pop <elendil@planet.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: pac207: problem with Trust USB webcam
Date: Sun, 21 Feb 2010 12:29:32 +0100
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org
References: <201002150038.03060.elendil@planet.nl> <4B7BAF8C.9070700@redhat.com> <201002171333.50579.elendil@planet.nl>
In-Reply-To: <201002171333.50579.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002211229.33252.elendil@planet.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 February 2010, Frans Pop wrote:
> Thanks a lot to you both for the pointers! I've gotten vlc to work using
> v4l1compat.so. The image is recognizable, but the color etc is way off.
> Haven't found a way to correct that yet.
>
> But the main thing for me ATM is that it's working now.

JFYI

I've backported vlc 1.0.5 (which has proper v4l2 support) to Debian stable 
and that works beautifully.

Cheers,
FJP
