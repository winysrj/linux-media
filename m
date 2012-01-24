Return-path: <linux-media-owner@vger.kernel.org>
Received: from cluster-k.mailcontrol.com ([116.50.57.190]:56839 "EHLO
	cluster-k.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2AXFNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 00:13:18 -0500
Received: from mail2.fujitsu.com.au (mail2.fujitsu.com.au [216.14.192.226])
	by rly08k.srv.mailcontrol.com (MailControl) with ESMTP id q0O4fjBH009197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 04:41:47 GMT
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail2.fujitsu.com.au (Postfix) with ESMTP id 953B14DB4CF
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 15:41:45 +1100 (EST)
Received: from mail2.fujitsu.com.au ([127.0.0.1])
	by localhost (mail2.fujitsu.com.au [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id n9AuxyJxYY+O for <linux-media@vger.kernel.org>;
	Tue, 24 Jan 2012 15:41:45 +1100 (EST)
Received: from SYD0633.au.fujitsu.com (unknown [137.172.78.132])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client did not present a certificate)
	by mail2.fujitsu.com.au (Postfix) with ESMTP id 6C5D44DB4C6
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 15:41:45 +1100 (EST)
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: HVR 4000 hybrid card still producing multiple frontends for single adapter
Date: Tue, 24 Jan 2012 15:41:01 +1100
Message-ID: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com>
From: "Hawes, Mark" <MARK.HAWES@au.fujitsu.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a HVR 4000 hybrid card  which provides both DVB-S2 and DVB-T capabilities on the one adapter. Using the current media tree build updated with the contents of the linux media drivers tarball dated 22/01/2012 the drivers for this card are still generating two frontends on the adapter as below:

> Jan 23 12:16:44 Nutrigrain kernel: [    9.346240] DVB: registering adapter 1 frontend 0 (Conexant CX24116/CX24118)...
> Jan 23 12:16:44 Nutrigrain kernel: [    9.349110] DVB: registering adapter 1 frontend 1 (Conexant CX22702 DVB-T)...

I understand that this behaviour is now deprecated and that the correct behaviour should be to generate one front end with multiple capabilities. Can this please be corrected.

Thanks,

Mark Hawes.

