Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43482 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0KGS5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Nov 2010 13:57:32 -0500
Subject: Re: [PATCH 3/3] i2c: Mark i2c_adapter.id as deprecated
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101105211001.1cc93ac7@endymion.delvare>
Date: Sun, 7 Nov 2010 13:57:29 -0500
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <5168EA09-2E17-4AF0-8919-4F83AC4E3E31@wilsonet.com>
References: <20101105211001.1cc93ac7@endymion.delvare>
To: Jean Delvare <khali@linux-fr.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Nov 5, 2010, at 4:10 PM, Jean Delvare wrote:

> It's about time to make it clear that i2c_adapter.id is deprecated.
> Hopefully this will remind the last user to move over to a different
> strategy.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jarod Wilson <jarod@redhat.com>


Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



