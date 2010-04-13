Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:45977 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0DMHur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 03:50:47 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Sarah Sharp <sarah.a.sharp@intel.com>
Subject: Re: xHCI bandwidth error with USB webcam
Date: Tue, 13 Apr 2010 09:50:45 +0200
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Libin <libin.yang@amd.com>, andiry.xu@amd.com,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <20100412222932.GA18647@xanatos>
In-Reply-To: <20100412222932.GA18647@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004130950.45576.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, 13. April 2010 00:29:32 schrieb Sarah Sharp:
> I figured out how to patch the gspca driver, but not uvcvideo.  The
> patch looks a bit hackish; can with experience with that driver look it
> over?  Can anyone tell me where to look for the usb_set_interface() in
> uvcvideo?

drivers/media/video/uvc/uvc_video.c::uvc_init_video()

But you'll have no luck there. uvcvideo already selects the altsetting
with the lowest bandwidth required for a resolution/format.

	Regards
		Oliver
