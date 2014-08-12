Return-path: <linux-media-owner@vger.kernel.org>
Received: from pindarots.xs4all.nl ([82.161.210.87]:58503 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaHLRXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 13:23:18 -0400
Message-ID: <53EA4D7D.80105@xs4all.nl>
Date: Tue, 12 Aug 2014 19:23:09 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: USB list <linux-usb@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <2923628.39nbDsJU79@avalon> <53E391E3.2050808@xs4all.nl> <53EA2DA2.4060605@redhat.com>
In-Reply-To: <53EA2DA2.4060605@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-08-12 17:07, Hans de Goede wrote:
> for you. Might be fixed by this commit:
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host?h=usb-next&id=3213b151387df0b95f4eada104f68eb1c1409cb3

That commit already appears to be in my kernel tree.

Kind regards,
Udo

