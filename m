Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:35242 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcB2S6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 13:58:00 -0500
Received: by mail-ig0-f193.google.com with SMTP id ww10so154220igb.2
        for <linux-media@vger.kernel.org>; Mon, 29 Feb 2016 10:57:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456104396-13282-3-git-send-email-emilio@elopez.com.ar>
References: <1456104396-13282-1-git-send-email-emilio@elopez.com.ar>
	<1456104396-13282-3-git-send-email-emilio@elopez.com.ar>
Date: Mon, 29 Feb 2016 15:57:59 -0300
Message-ID: <CABxcv=nAUWfhHC-2jpTUHbk4PzyGL7D8jUJ33mXU0Aq7Xu7GAg@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb: musb: sunxi: support module autoloading
From: Javier Martinez Canillas <javier@dowhile0.org>
To: =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>
Cc: Vinod Koul <vinod.koul@intel.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	balbi@kernel.org, Hans de Goede <hdegoede@redhat.com>,
	dmaengine@vger.kernel.org,
	=?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio.lopez@collabora.co.uk>,
	USB list <linux-usb@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Emilio,

On Sun, Feb 21, 2016 at 10:26 PM, Emilio López <emilio@elopez.com.ar> wrote:
> From: Emilio López <emilio.lopez@collabora.co.uk>
>
> MODULE_DEVICE_TABLE() is missing, so the module isn't auto-loading on
> sunxi systems using the OTG controller. This commit adds the missing
> line so it loads automatically when building it as a module and running
> on a system with an USB OTG port.
>
> Signed-off-by: Emilio López <emilio.lopez@collabora.co.uk>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
