Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Keun7-0004yb-Ej
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 18:49:43 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K77003LZ2PUVC80@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 12:49:07 -0400 (EDT)
Date: Sun, 14 Sep 2008 12:49:06 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809141656.39538.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48CD4082.9020209@linuxtv.org>
MIME-version: 1.0
References: <48CA0355.6080903@linuxtv.org> <48CC12BF.7050803@hauppauge.com>
	<200809141646.01263.hftom@free.fr> <200809141656.39538.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christophe Thommeret wrote:
> Le Sunday 14 September 2008 16:46:01 Christophe Thommeret, vous avez =E9c=
rit :
> =

>> (Exept for the cinergyT2 case off course)
> Missworded, cinergyT2 has always worked wit old api.
> I menat, all devices work now as expected with both old and new api, exce=
pt =

> cinergyT2 which only works with old api.
> =


I understood what you meant, but thanks for clarifying.

I posted a patch to the list a few mins ago. If S2API is accept we'll =

debug the patch and get the device withing with the new API. It's an old =

driver (2004) but it's still being used.... it should probably come back =

to dvb-core unless anyone has significant reasons why it should not.

Thanks,

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
