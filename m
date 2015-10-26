Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59127 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbbJ0AnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 20:43:07 -0400
In-Reply-To: <1445901232.9389.2.camel@gmail.com>
References: <1445901232.9389.2.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: PVR-250 Composite 3 unavailable [Re: ivtv driver]
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 26 Oct 2015 19:49:02 -0400
To: Warren Sturm <warren.sturm@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	andy <andy@silverblocksystems.net>
Message-ID: <77A58399-549F-4A8A-8F87-8F40B7756D3A@md.metrocast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On October 26, 2015 7:13:52 PM EDT, Warren Sturm <warren.sturm@gmail.com> wrote:
>Hi Andy.
>
>I don't know whether this was intended but the pvr250 lost the
>composite 3 input when going from kernel version 4.1.10 to 4.2.3.
>
>This is on a Fedora 22 x86_64 system.
>
>
>Thanks for any insight.

Unintentional.

I'm guessing this commit was the problem:

http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/drivers/media/pci/ivtv/ivtv-driver.c?id=09290cc885937cab3b2d60a6d48fe3d2d3e04061

Could you confirm?

R,
Andy
