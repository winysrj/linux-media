Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:44856 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZDFMrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 08:47:33 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LqpJY-0003da-Po
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Mon, 06 Apr 2009 15:56:41 +0200
Date: Mon, 6 Apr 2009 14:47:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: Re: v4l-dvb repository doesn't build
Message-ID: <20090406144724.38894170@hyperion.delvare>
In-Reply-To: <20090406103252.4ee1ee0a@hyperion.delvare>
References: <20090406103252.4ee1ee0a@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Apr 2009 10:32:52 +0200, Jean Delvare wrote:
> My latest pull of the v4l-dvb repository this morning broke the build:
> make[3]: *** No rule to make target `/home/khali/src/v4l-dvb/v4l/cx88-dsp.o', needed by `/home/khali/src/v4l-dvb/v4l/tda18271.o'.  Stop.
> 
> I am building against kernel 2.6.29.1. Yesterday it was building OK. I
> can't make any sense of this error. Help anyone?

For the records: that was a missing file in the repository, Mauro just
fixed it.

-- 
Jean Delvare
