Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61259 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1LVWkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 17:40:32 -0500
Received: by yenm11 with SMTP id m11so5523666yen.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 14:40:31 -0800 (PST)
Message-ID: <4EF3B1D3.3040500@aapt.net.au>
Date: Fri, 23 Dec 2011 09:40:19 +1100
From: Andrew Goff <goffa72@gmail.com>
Reply-To: goffa72@gmail.com
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx88: all radio tuners using xc2028 or xc4000 tuner and radio
 should have radio_type UNSET
References: <CAEN_-SC1bPX-SWS5ZV7=7ANTAhbjEQpUTog7GATOxTJqyq+R-w@mail.gmail.com>
In-Reply-To: <CAEN_-SC1bPX-SWS5ZV7=7ANTAhbjEQpUTog7GATOxTJqyq+R-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Miroslav,

your patches fixed the problems with my leadtek 1800H card. Radio now 
works again and tunes to the correct frequency.

On 17/12/2011 11:55 AM, Miroslav Slugeň wrote:
> Fix radio for cx88 driver.
