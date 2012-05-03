Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:49505 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2ECK5V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 06:57:21 -0400
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 03 May 2012 12:57:00 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>, <mchehab@redhat.com>,
	<nbowler@elliptictech.com>, <james.dutton@gmail.com>
In-Reply-To: <20120502213915.GG852@valkosipuli.localdomain>
References: <20120502191324.GE852@valkosipuli.localdomain> <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi> <201205022245.22585.hverkuil@xs4all.nl> <20120502213915.GG852@valkosipuli.localdomain>
Message-ID: <2ce6f5bbb2d0c3b1c7e9e77a2e4a89cf@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 May 2012 00:39:15 +0300, Sakari Ailus <sakari.ailus@iki.fi>

wrote:

> - ppc64: int is 64 bits there, and thus also enums,



Really?



(e)glibc assumes that signed int and unsigned int are 32-bits on all

platforms. From bits/types.h:



typedef signed int __int32_t;

typedef unsigned int __uint32_t;



> - C does not specify which integer type enums actually use; this is what

> GCC manual says about it:



The Linux ABI, at least as defined in GCC, requires 'short enums' be

disabled, even on ARM.

So enums should always be unsigned or int with gcc, thus with V4L2 code.



-- 

Rémi Denis-Courmont
