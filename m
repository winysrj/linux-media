Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <scha0273@planet.nl>) id 1JQjMl-0000qK-Ng
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 14:15:35 +0100
Message-ID: <47B83357.50207@planet.nl>
Date: Sun, 17 Feb 2008 14:15:03 +0100
From: henk schaap <haschaap@planet.nl>
MIME-Version: 1.0
To: Igor <goga777@bk.ru>
References: <47B6A9DB.501@planet.nl>
	<E1JQJvK-000BwB-00.goga777-bk-ru@f128.mail.ru>
In-Reply-To: <E1JQJvK-000BwB-00.goga777-bk-ru@f128.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] multiproto and tt3200: don't get a lock
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1607080068=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1607080068==
Content-Type: text/html; charset=KOI8-R
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=KOI8-R" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Igor, <br>
<br>
Thank you for pointing me in the good direction. I checked the szap.c
from Manu again and noticed that I had to change the declarations of
the include files frontend.h and lnb.h (I copied them from the
multiproto-tree to the same directory as szap.c). It seems to be that <u>#include
&lt;frontend.h&gt;</u> has a different meaning than <u>#include
"frontend.h"</u> (I am not familiair with C).<br>
<br>
This means for szap.c:<br>
#include "frontend.h"<br>
#include "version.h"<br>
#include "lnb.h"<br>
And for lnb.c:<br>
#include "lnb.h"<br>
<br>
This is it. After compiling szap works good and I get a lock for any
channel!<br>
<br>
Thanks!<br>
<br>
Henk<br>
<br>
</body>
</html>


--===============1607080068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1607080068==--
