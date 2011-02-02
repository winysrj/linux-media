Return-path: <mchehab@pedra>
Received: from node-1.vhosting-it.com ([178.63.175.16]:56370 "EHLO
	yavin4.bsod.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113Ab1BBMfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 07:35:42 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Feb 2011 13:30:09 +0100
From: Francesco <francesco@bsod.eu>
To: <linux-media@vger.kernel.org>
Cc: <francesco@bsod.eu>
Subject: libv4l compile on uclibc
Message-ID: <710dab092054ffa3e12fbf493dd9b4da@127.0.0.1>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Good afternoon.
I'm trying to compile v4l-utils for uclibc, but i need only libv4l for 
my purpose.

In order to compile correctly, is should have argp.h, but in the 
distribution i'm using uclibc is not compiled with argp.h.
Because this library is used in :

v4l2grab.c:#include <argp.h>
decode_tm6000/decode_tm6000.c:#include <argp.h>
utils/keytable/keytable.c:#include <argp.h>

but i don't need this part of utils, is possible compile only libv4l 
without using argp.h ?

Thanks in advance.


--
:: Francesco ::
Jabber: francesco@jabber.org
E-Mail: francesco@bsod.eu
GnuPG: FE9DDD5F

