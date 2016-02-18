Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:42405 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbcBRHiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 02:38:54 -0500
Received: from [192.168.1.138] (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 94D0728649
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2016 08:38:47 +0100 (CET)
Subject: Re: Terratec CINERGY T/C Stick
To: linux-media <linux-media@vger.kernel.org>
References: <20160217201920.yq8h5szz5wogsso0@www.mail4me.at>
 <56C572E6.8060301@southpole.se>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <56C57507.4080901@southpole.se>
Date: Thu, 18 Feb 2016 08:38:47 +0100
MIME-Version: 1.0
In-Reply-To: <56C572E6.8060301@southpole.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
> Open the device take some pictures and tell us what chips are inside. It
> might be easy to add support.
>
> MvH
> Benjamin Larsson

I think it is a RTL2832 (T demod + usb bridge) + a RTL2840 (C demod) 
combo. The rtl2832 driver code is there but there is no rtl3240 code.

MvH
Benjamin Larsson
