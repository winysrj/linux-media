Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:52177 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933007Ab2EVUhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 16:37:33 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/6] snd_tea575x: Various patches
Date: Tue, 22 May 2012 22:37:01 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201205222237.04867.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 20 May 2012 03:25:25 Hans de Goede wrote:
> Hi All,
>
> This patch series contains various patches for the tea575x driver to
> prepare for adding support for the Griffin radioSHARK device. The 6th patch
> adds support for tuning AM, which depends on the discussions surrounding
> the v4l2 API and radio devices with multiple tuners. I plan to add patches
> 1-5 to my next pull request to Mauro, I will leave patch 6 out until the
> API discussion is done.

I tested the patches with FM-only card (SF16-FMD2) and haven't found any 
problems.

-- 
Ondrej Zary
