Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skynet.fr ([91.121.146.144]:33675 "EHLO mail.skynet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1IWVPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 17:15:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.skynet.fr (Postfix) with ESMTP id 052A610314A
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 21:06:31 +0000 (UTC)
Received: from mail.skynet.fr ([127.0.0.1])
	by localhost (mail.skynet.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z2fPu-npy+cX for <linux-media@vger.kernel.org>;
	Fri, 23 Sep 2011 21:06:30 +0000 (UTC)
Received: from Jin-Kazamas-MacBook-Pro.local (gli74-3-78-241-6-73.fbx.proxad.net [78.241.6.73])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: mathieu@seillon.fr)
	by mail.skynet.fr (Postfix) with ESMTPSA id 996FD10203C
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 21:06:30 +0000 (UTC)
Message-ID: <4E7CF4DA.5020607@skynet.fr>
Date: Fri, 23 Sep 2011 23:06:34 +0200
From: Jin Kazama <jin.ml@skynet.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: af9015/tda18218: Multiples (separates) usb devices errors/conflicts
References: <S1752295Ab1IWUja/20110923203930Z+74@vger.kernel.org>
In-Reply-To: <S1752295Ab1IWUja/20110923203930Z+74@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
	I've been testing af9015/tda18218 based usb DVB-T tuners on a 2.6.39.4 
kernel with the latest v4l drivers avaiable (from git).
	When I'm using a single USB module, (listed as /dev/dvb/adapter0), 
everything works fine.
	When I'm plugging another module, at first it looks like everything's 
ok (/dev/dvb/adapter1) and if I try to use this module while the 
adapter0 is not been used, it works - but if try to use both modules at 
the same time, I get garbage output on both cards (error: warning: 
discontinuity for PID... with dvblast on both cards.
	Does anyone have any idea on how to fix this problem?
