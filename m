Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:49146 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0C0Mjg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 08:39:36 -0400
Received: from kabelnet-194-37.juropnet.hu ([91.147.194.37])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NvVIa-0007Fb-Sw
	for linux-media@vger.kernel.org; Sat, 27 Mar 2010 13:39:35 +0100
Message-ID: <4BADFDE9.8020900@mailbox.hu>
Date: Sat, 27 Mar 2010 13:45:29 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cx88: fix setting input when using DVB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In cx88-mpeg.c, there is code that sets core->input to CX88_VMUX_DVB.
However, this may be incorrect, since core->input is actually an
index to core->board.input[], which has not enough elements to be
indexed by the value of CX88_VMUX_DVB. So, the modified code searches
core->board.input[] for an input with a type of CX88_VMUX_DVB, and if
it does not find one, the index is simply set to zero.
The change may not have much effect, though, since it appears the only
case when core->input is actually used is when the current input is
being queried.

Signed-off-by: Istvan Varga <istvanv@users.sourceforge.net>

