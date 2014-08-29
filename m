Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48904 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaH2Nq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 09:46:56 -0400
Message-ID: <5400844A.5030603@collabora.com>
Date: Fri, 29 Aug 2014 09:46:50 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: k.debski@samsung.com
Subject: Bug: s5p-mfc should allow multiple call to REQBUFS before we start
 streaming
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

after a discussion on IRC, we concluded that s5p-mfc have this bug that 
disallow multiple reqbufs calls before streaming. This has the impact 
that it forces to call REQBUFS(0) before setting the new number of 
buffers during re-negotiation, and is against the spec too.

As an example, in reqbufs_output() REQBUFS is only allowed in QUEUE_FREE 
state, and setting buffers exits this state. We think that the call to 
<http://lxr.free-electrons.com/ident?i=reqbufs_output>s5p_mfc_open_mfc_inst() 
should be post-poned until STREAMON is called. 
<http://lxr.free-electrons.com/ident?i=reqbufs_output>

cheers,
Nicolas
<http://lxr.free-electrons.com/ident?i=reqbufs_output>
