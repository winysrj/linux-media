Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:43475 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720AbaFSIZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 04:25:01 -0400
Message-ID: <53A29E5A.9030304@dest-unreach.be>
Date: Thu, 19 Jun 2014 10:24:58 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
CC: James Hogan <james.hogan@imgtec.com>,
	=?ISO-8859-1?Q?David_H=E4rdem?= =?ISO-8859-1?Q?an?=
	<david@hardeman.nu>,
	=?ISO-8859-1?Q?Antti_Sepp=E4l?= =?ISO-8859-1?Q?=E4?=
	<a.seppala@gmail.com>
Subject: [PATCH 0/2] drivers/media/rc/ir-nec-decode : add toggle feature
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The IR NEC protocol decoder does not handle repeated key presses very
well. It is regarded the same as a long key press, an thus triggers the
auto-repeat functionality, which is not what I expected.

The first patch solves the issue; the second patch fixes indentation
inside the (new) if-block. I kept these 2 separate to make it more clear
what the functional changes are, and which lines were only indented/reflown.

Niels
