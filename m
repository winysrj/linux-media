Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49297 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0GaLPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 07:15:00 -0400
Message-ID: <4C5405A2.4050102@s5r6.in-berlin.de>
Date: Sat, 31 Jul 2010 13:14:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: Handling of large keycodes
References: <20100731091936.GA22253@core.coreip.homeip.net> <4C5402FE.2080002@s5r6.in-berlin.de>
In-Reply-To: <4C5402FE.2080002@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
>   - I take it from your description that scan codes are fundamentally
>     variable-length data.  How about defining it as __u8 scancode[0]?

Forget this; that would make it difficult to extend the ABI later by
adding more struct members.
-- 
Stefan Richter
-=====-==-=- -=== =====
http://arcgraph.de/sr/
