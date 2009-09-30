Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.agmk.net ([91.192.224.71]:41584 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZI3Lwd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 07:52:33 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Date: Wed, 30 Sep 2009 13:52:27 +0200
Cc: linux-kernel@vger.kernel.org, LMML <linux-media@vger.kernel.org>
References: <200909160300.28382.pluto@agmk.net> <200909301016.15327.pluto@agmk.net> <20090930125737.704413c8@hyperion.delvare>
In-Reply-To: <20090930125737.704413c8@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909301352.28362.pluto@agmk.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 30 September 2009 12:57:37 Jean Delvare wrote:

> Are you running distribution kernels or self-compiled ones?
> Any local patches applied?
> Would you be able to apply debug patches and rebuild your kernel?

yes, i'm using patched (vserver,grsec) modular kernel from pld-linux
but i'm able to boot custom git build and do the bisect if necessary.
