Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:43676 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZD2M37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 08:29:59 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LzA0o-0000Fh-Q5
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Wed, 29 Apr 2009 15:39:47 +0200
Date: Wed, 29 Apr 2009 14:29:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model
 (v2)
Message-ID: <20090429142952.65d1c923@hyperion.delvare>
In-Reply-To: <20090417222927.7a966350@hyperion.delvare>
References: <20090417222927.7a966350@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2009 22:29:27 +0200, Jean Delvare wrote:
> Here comes an update of my conversion of ir-kbd-i2c to the new i2c
> binding model. I've split it into 6 pieces for easier review. (...)

Did anyone test these patches, please?

-- 
Jean Delvare
