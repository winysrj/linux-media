Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:43401 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab2DMT55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 15:57:57 -0400
Received: from basile.localnet (ip6-localhost [IPv6:::1])
	by oyp.chewa.net (Postfix) with ESMTP id 2DF9A201BA
	for <linux-media@vger.kernel.org>; Fri, 13 Apr 2012 21:57:44 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 1/3] Support integer menus.
Date: Fri, 13 Apr 2012 22:57:53 +0300
References: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi> <2967674.Tm7K8VO7YX@avalon>
In-Reply-To: <2967674.Tm7K8VO7YX@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204132257.53893.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 13 avril 2012 22:47:14 Laurent Pinchart, vous avez écrit :
> Hi Sakari,
> 
> Thanks for the patch.
> 
> The code looks fine, but unfortunately breaks compilation when using kernel
> headers < v3.5 (which is a pretty common case as of today ;-)).
> 
> V4L2_CTRL_TYPE_INTEGER_MENU is an enumerated value, not a pre-processor
> #define, so it's difficult to test for it using conditional compilation.

Same problem with BITMASK already.

The most common solution to this problem, although not found in V4L consists 
of defining the enumeration members in the header <linux/videodev2.h>:

#define V4L2_CTRL_TYPE_INTEGER_MENU V4L2_CTRL_TYPE_INTEGER_MENU

Then #ifdef works fine. libc has plenty of these, e.g. <bits/socket.h>. Or per 
package, autoconf can be used:

AC_CHECK_HEADERS([linux/videodev2.h sys/videoio.h])
AC_CHECK_DECLS([V4L2_CTRL_TYPE_INTEGER_MENU],,, [
#ifdef HAVE_LINUX_VIDEODEV2_H
# include <linux/videodev2.h>
#endif
#ifdef HAVE_SYS_VIDEOIO_H
# include <sys/videoio.h>
#endif
])

Then this works:

#if HAVE_DECL_V4L2_CTRL_TYPE_INTEGER_MENU



-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
