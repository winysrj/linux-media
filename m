Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:43458 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab2FSPpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 11:45:10 -0400
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: Rodolfo Timoteo da Silva <zhushazang@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 19 Jun 2012 16:43:47 +0100
Subject: RE: DiBcom adapter problems
Message-ID: <C73E570AC040D442A4DD326F39F0F00E138E9533E7@SAPHIR.xi-lite.lan>
References: <4FDDE29B.9040500@gmail.com>
In-Reply-To: <4FDDE29B.9040500@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
can you provide more information:
    - kernel version
    - more log information (not only the error message but also the log from the beginning, when you plug the device) with:
          * the debug parameter of the dib8000 module set to 1
          * the frontend_debug parameter of the dvb-core module set to 1
    - which application do you use to tune the board

regards,
Olivier
________________________________________
From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Rodolfo Timoteo da Silva [zhushazang@gmail.com]
Sent: Sunday, June 17, 2012 3:58 PM
To: linux-media@vger.kernel.org
Subject: DiBcom adapter problems

Hi, every time that i try to syntonize DVB-T channels i receive a
message in kernel like in log1.txt arch.

There are in log2.txt some usefull information about the device.

My kernel/system is:


Linux version 3.4.2-gentoo-r1-asgard (root@asgard) (gcc version 4.6.3
(Gentoo 4.6.3 p1.3, pie-0.5.2) ) #1 SMP PREEMPT Thu Jun 14 07:45:19 BRT 2012

Best Regards
