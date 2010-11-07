Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34705 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0KGS4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Nov 2010 13:56:32 -0500
Subject: Re: [PATCH 1/3] i2c: Delete unused adapter IDs
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101105210645.6e47498c@endymion.delvare>
Date: Sun, 7 Nov 2010 13:56:29 -0500
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <833D252B-AB88-4895-849F-2F8C8E5400A6@wilsonet.com>
References: <20101105210645.6e47498c@endymion.delvare>
To: Jean Delvare <khali@linux-fr.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Nov 5, 2010, at 4:06 PM, Jean Delvare wrote:

> Delete unused I2C adapter IDs. Special cases are:
> 
> * I2C_HW_B_RIVA was still set in driver rivafb, however no other
>  driver is ever looking for this value, so we can safely remove it.
> * I2C_HW_B_HDPVR is used in staging driver lirc_zilog, however no
>  adapter ID is ever set to this value, so the code in question never
>  runs. As the code additionally expects that I2C_HW_B_HDPVR may not
>  be defined, we can delete it now and let the lirc_zilog driver
>  maintainer rewrite this piece of code.
> 
> Big thanks for Hans Verkuil for doing all the hard work :)
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jarod Wilson <jarod@redhat.com>

I think I2C_HW_B_HDPVR was only being used by a not-yet-merged-upstream patch to the hdpvr driver, which enabled the IR functionality on it. Its not merged, as enabling it seems to like to lock the unit up from time to time, and nobody (myself included) has had time to figure out why. In any case, it should be perfectly fine to nuke that, we need to fix lirc_zilog regardless.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



