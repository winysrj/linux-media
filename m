Return-path: <mchehab@pedra>
Received: from adelie.canonical.com ([91.189.90.139]:34817 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab0KRHbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 02:31:01 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Mariusz =?utf-8?q?Bia=C5=82o=C5=84czyk?= <manio@skyboo.net>
Subject: Re: [PATCH] V4L/DVB: cx88: Add module parameter to disable IR
Date: Thu, 18 Nov 2010 15:30:49 +0800
Cc: linux-media@vger.kernel.org
References: <1290062581.41867.321546213719.1.gpush@pororo> <4CE4D3D5.5090108@skyboo.net>
In-Reply-To: <4CE4D3D5.5090108@skyboo.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011181530.49916.jeremy.kerr@canonical.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mariusz,

> AFAIK we have disable support in cx88:
> http://git.linuxtv.org/media_tree.git?a=commit;h=89c3bc78075042ae1f4452687f
> 626acce06b3b21

Ah, my bad - I was working off Linus' tree, and looks like that patch hasn't 
hit mainline yet.

As an aside, that patch has a problem: the MODULE_PARAM_DESC line uses 
'latency', not 'disable_ir'.

Cheers,


Jeremy
