Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub0-omc2-s12.dub0.hotmail.com ([157.55.1.151]:2155 "EHLO
	dub0-omc2-s12.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162Ab3LLPaQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 10:30:16 -0500
Message-ID: <DUB118-W85FE8760B56F111FD1AA69CDC0@phx.gbl>
From: David Binderman <dcb314@hotmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: v4l-utils-1.0.0 bug report
Date: Thu, 12 Dec 2013 15:25:07 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

I just ran the static analysis tool "cppcheck" over the
source code of v4l-utils-1.0.0. It said many things, including

1. [rds-saa6588.c:119]: (style) Expression '(X & 0x8) == 0x1' is always false.

Source code is

    if (1 == (b[0] & 0x08)) {

Maybe the programmer intended

    if (0 != (b[0] & 0x08)) {

2.[rds-saa6588.c:122]: (style) Expression '(X & 0x4) == 0x1' is always false.

Source code is

   if (1 == (b[0] & 0x04)) {

Duplicate.

Regards

David Binderman 		 	   		  