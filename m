Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:40710 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1KXGYX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 01:24:23 -0500
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [Query] V4L2 Integer =?UTF-8?Q?=28=3F=29=20menu=20control?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 24 Nov 2011 07:24:20 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
In-Reply-To: <4ECD730E.3080808@gmail.com>
References: <4ECD730E.3080808@gmail.com>
Message-ID: <0acb6fa3fc87692f1f8ac7f1a908e1e7@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 23 Nov 2011 23:26:22 +0100, Sylwester Nawrocki <snjw23@gmail.com>

wrote:

> I don't seem to find a way to implement this in current v4l2 control

> framework.  Such functionality isn't there, or is it ?



You can use the menu control type, but you will need to remap the control

values so they are continuous.



-- 

Rémi Denis-Courmont

http://www.remlab.net/
