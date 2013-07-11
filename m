Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:37801 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3GKMes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 08:34:48 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Juergen Stuber <starblue@users.sourceforge.net>
Subject: Re: [PATCH 08/50] USB: legousbtower: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 14:36:23 +0200
Message-ID: <3187374.nPY1jDDWKm@linux-5eaq.site>
In-Reply-To: <51DEA289.5050509@cogentembedded.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-9-git-send-email-ming.lei@canonical.com> <51DEA289.5050509@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 July 2013 16:18:17 Sergei Shtylyov wrote:

>     I don't think this patch passes checkpatch.pl.

This series is a mechanical replacement in dozens of drivers.
We cannot demand nice formatting. If you want to do something
productive, check the locking in the driver.

	Regards
		Oliver

