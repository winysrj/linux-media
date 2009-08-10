Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:49208 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZHJQGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 12:06:30 -0400
Message-ID: <4A804585.9060908@pardus.org.tr>
Date: Mon, 10 Aug 2009 19:06:29 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] NULL pointer dereference in ALSA triggered	through
 saa7134-alsa
References: <4A8025BF.7030404@pardus.org.tr> <s5hab27n501.wl%tiwai@suse.de>	<4A803FDC.8070005@pardus.org.tr> <s5hocqnllcg.wl%tiwai@suse.de>
In-Reply-To: <s5hocqnllcg.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Takashi Iwai wrote:
> But /usr/include/sound isn't used for building kernel modules normally.
> Unless any hack is added, these files have to be installed to the
> kernel header directory.
>   

Ah you're right, I totally missed that one. Thanks, will try to
workaround that.
