Return-path: <linux-media-owner@vger.kernel.org>
Received: from cgmail.impactmoto.com ([66.167.228.140]:49006 "EHLO
	impactmoto.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760622AbZLJLQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 06:16:36 -0500
Received: from [192.168.0.5] (HELO DC.impactmoto.com)
  by impactmoto.com (CommuniGate Pro SMTP 5.2.13)
  with ESMTPS id 9903672 for linux-media@vger.kernel.org; Thu, 10 Dec 2009 02:16:41 -0800
From: Jeremy Simmons <jeremy@impactmoto.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 10 Dec 2009 02:16:35 -0800
Subject: Re: Compile Error - ir-keytable
Message-ID: <A8BEBCEF90A5AC498E0DAEADEBB06AD7EA9C2BEB08@DC.impactmoto.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm having the same problem.  Any solution?

-Jeremy




________________________________________
* Subject: Compile Error - ir-keytable 
* From: David Carlo <dcarlo@xxxxxxxxxxxx> 
* Date: Wed, 2 Dec 2009 11:56:22 -0500 
________________________________________
Hello.  I'm compiling the v4l kernel drivers in an attempt to use my hdpvr
with CentOS 5.4.  When I compile v4l, I'm getting this error:

=============================================================================
<snip>
  CC [M]  /usr/local/src/v4l-dvb/v4l/ir-functions.o
  CC [M]  /usr/local/src/v4l-dvb/v4l/ir-keymaps.o
  CC [M]  /usr/local/src/v4l-dvb/v4l/ir-keytable.o
/usr/local/src/v4l-dvb/v4l/ir-keytable.c: In function
'ir_g_keycode_from_table':
/usr/local/src/v4l-dvb/v4l/ir-keytable.c:181: error: implicit declaration of
function 'input_get_drvdata'
/usr/local/src/v4l-dvb/v4l/ir-keytable.c:181: warning: initialization makes
pointer from integer without a cast
/usr/local/src/v4l-dvb/v4l/ir-keytable.c: In function 'ir_input_free':
/usr/local/src/v4l-dvb/v4l/ir-keytable.c:236: warning: initialization makes
pointer from integer without a cast
make[3]: *** [/usr/local/src/v4l-dvb/v4l/ir-keytable.o] Error 1
make[2]: *** [_module_/usr/local/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.18-164.6.1.el5-x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/src/v4l-dvb/v4l'
make: *** [all] Error 2
=============================================================================

Here are the stats on my box:
  CentOS 5.4 x86_64
  kernel 2.6.18-164.6.1.el5-x86_64
  gcc 4.1.2

Has anyone else seen this?

    --Dave

