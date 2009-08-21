Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55599 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbZHUQCe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 12:02:34 -0400
Message-ID: <4A8EC51B.20902@nildram.co.uk>
Date: Fri, 21 Aug 2009 17:02:35 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: compat.h required to build 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following files:

/linux/drivers/media/dvb/frontends/stb6100.c
/linux/drivers/media/dvb/frontends/tda10021.c
/linux/drivers/media/dvb/frontends/ves1820.c

Fail to build with:

error: implicit declaration of function 'DIV_ROUND_CLOSEST'

and need the addition of:

#include "compat.h"

when building on my system. Is this related to my kernel version 
(2.6.28) or is it something else?

Thanks,

Lou

