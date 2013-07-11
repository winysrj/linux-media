Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:64892 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKNrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 09:47:08 -0400
Received: by mail-la0-f53.google.com with SMTP id fs12so6834649lab.12
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 06:47:06 -0700 (PDT)
Message-ID: <51DEB757.6070202@cogentembedded.com>
Date: Thu, 11 Jul 2013 17:47:03 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Juergen Stuber <starblue@users.sourceforge.net>
Subject: Re: [PATCH 08/50] USB: legousbtower: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-9-git-send-email-ming.lei@canonical.com> <51DEA289.5050509@cogentembedded.com> <3187374.nPY1jDDWKm@linux-5eaq.site>
In-Reply-To: <3187374.nPY1jDDWKm@linux-5eaq.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 11-07-2013 16:36, Oliver Neukum wrote:

>>      I don't think this patch passes checkpatch.pl.

> This series is a mechanical replacement in dozens of drivers.

    That mechanicity shows too much in some patches.

> We cannot demand nice formatting.  If you want to do something
> productive, check the locking in the driver.

    I'm not paid for it and don't have time to do it for free.

> 	Regards
> 		Oliver

WBR, Sergei


