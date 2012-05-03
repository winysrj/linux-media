Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:49554 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab2ECK7Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 06:59:16 -0400
To: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 03 May 2012 12:58:57 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	<linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<mchehab@redhat.com>, <nbowler@elliptictech.com>,
	<james.dutton@gmail.com>
In-Reply-To: <2ce6f5bbb2d0c3b1c7e9e77a2e4a89cf@chewa.net>
References: <20120502191324.GE852@valkosipuli.localdomain> <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi> <201205022245.22585.hverkuil@xs4all.nl> <20120502213915.GG852@valkosipuli.localdomain> <2ce6f5bbb2d0c3b1c7e9e77a2e4a89cf@chewa.net>
Message-ID: <3b9e7aa585169179c0140508e72cf97b@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Answering myself.



On Thu, 03 May 2012 12:57:00 +0200, Rémi Denis-Courmont <remi@remlab.net>

wrote:

> On Thu, 3 May 2012 00:39:15 +0300, Sakari Ailus <sakari.ailus@iki.fi>

> wrote:

>> - ppc64: int is 64 bits there, and thus also enums,

> 

> Really?



No, really not:

http://refspecs.linuxfoundation.org/ELF/ppc64/PPC-elf64abi-1.9.html#FUND-TYPE



-- 

Rémi Denis-Courmont

Sent from my collocated server
