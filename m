Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morfsta@gmail.com>) id 1Jc5Yp-0001Ze-Ke
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 22:11:02 +0100
Received: by rn-out-0910.google.com with SMTP id e11so521455rng.17
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 14:10:48 -0700 (PDT)
Message-ID: <eddfa47b0803191400k2368eebfo4da7aa1930e2c0cc@mail.gmail.com>
Date: Wed, 19 Mar 2008 21:00:46 +0000
From: Morfsta <morfsta@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] HVR4000 patch and Latest Multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Well, it seems that the January HVR4000 patch no longer works with multiproto: -

/root/multiproto/v4l/cx24116.c:1506: error: unknown field 'delivery'
specified in initializer
/root/multiproto/v4l/cx24116.c:1506: warning: missing braces around initializer
/root/multiproto/v4l/cx24116.c:1506: warning: (near initialization for
'dvbs_info.delsys')
/root/multiproto/v4l/cx24116.c:1525: error: unknown field 'delivery'
specified in initializer
/root/multiproto/v4l/cx24116.c:1525: warning: missing braces around initializer
/root/multiproto/v4l/cx24116.c:1525: warning: (near initialization for
'dvbs2_info.delsys')
/root/multiproto/v4l/cx24116.c: In function 'cx24116_get_info':
/root/multiproto/v4l/cx24116.c:1551: error: 'struct dvbfe_info' has no
member named 'delivery'

Anyone got any ideas on how to fix this?

Cheers,

Morfsta

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
