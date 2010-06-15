Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61148 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0FOAY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 20:24:59 -0400
Date: Mon, 14 Jun 2010 21:24:49 -0300
From: "Gustavo F. Padovan" <gustavo@padovan.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8]bluetooth/hci_ldisc.c Fix warning: variable 'tty'
 set but not used
Message-ID: <20100615001444.GC9203@vigoh>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-3-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276547208-26569-3-git-send-email-justinmattock@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Justin,

* Justin P. Mattock <justinmattock@gmail.com> [2010-06-14 13:26:42 -0700]:

> Im getting this while building:
>   CC [M]  drivers/bluetooth/hci_ldisc.o
> drivers/bluetooth/hci_ldisc.c: In function 'hci_uart_send_frame':
> drivers/bluetooth/hci_ldisc.c:213:21: warning: variable 'tty' set but not used
> 
> the below fixed it for me, but am not sure if
> it's correct.


The fix is correct, you just need to fix the trailing whitespace
problem and resend it.
Also we use "Bluetooth:" as part of the commit message on the bluetooth
subsystem. For example:

"Bluetooth: Remove set but not used varible 'tty' 

Or something like that.

-- 
Gustavo F. Padovan
http://padovan.org
