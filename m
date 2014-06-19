Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:52438 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454AbaFSL7u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 07:59:50 -0400
Message-ID: <53A2D0B5.4050003@dest-unreach.be>
Date: Thu, 19 Jun 2014 13:59:49 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/media/rc/ir-nec-decode : add toggle feature
References: <53A29E5A.9030304@dest-unreach.be> <53A29E79.2000304@dest-unreach.be> <20140619090540.GC13952@hardeman.nu>
In-Reply-To: <20140619090540.GC13952@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-06-19 11:05, David Härdeman wrote:
> On Thu, Jun 19, 2014 at 10:25:29AM +0200, Niels Laukens wrote:
>> Made the distinction between repeated key presses, and a single long
>> press. The NEC-protocol does not have a toggle-bit (cfr RC5/RC6), but
>> has specific repeat-codes.
> 
> Not all NEC remotes use repeat codes. Some just transmit the full code
> at fixed intervals...IIRC, Pioneer remotes is (was?) one example... 

A way to cover this, is to make this mechanism optional, and
auto-activate as soon as a repeat code is seen. But that will only work
reliably with a single (type of) remote per system. Is this a better
solution?


Niels
