Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1Jc6fJ-0007ms-Ks
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 23:21:46 +0100
Received: by ik-out-1112.google.com with SMTP id b32so457487ika.1
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 15:21:41 -0700 (PDT)
Date: Wed, 19 Mar 2008 23:21:37 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20080319222137.GA30672@gmail.com>
References: <eddfa47b0803191400k2368eebfo4da7aa1930e2c0cc@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eddfa47b0803191400k2368eebfo4da7aa1930e2c0cc@mail.gmail.com>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] HVR4000 patch and Latest Multiproto
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

On Wed, Mar 19, 2008 at 09:00:46PM +0000, Morfsta wrote:
> Well, it seems that the January HVR4000 patch no longer works with multip=
roto: -
> =

> /root/multiproto/v4l/cx24116.c:1506: error: unknown field 'delivery'
> specified in initializer
> /root/multiproto/v4l/cx24116.c:1506: warning: missing braces around initi=
alizer
> /root/multiproto/v4l/cx24116.c:1506: warning: (near initialization for
> 'dvbs_info.delsys')
> /root/multiproto/v4l/cx24116.c:1525: error: unknown field 'delivery'
> specified in initializer
> /root/multiproto/v4l/cx24116.c:1525: warning: missing braces around initi=
alizer
> /root/multiproto/v4l/cx24116.c:1525: warning: (near initialization for
> 'dvbs2_info.delsys')
> /root/multiproto/v4l/cx24116.c: In function 'cx24116_get_info':
> /root/multiproto/v4l/cx24116.c:1551: error: 'struct dvbfe_info' has no
> member named 'delivery'
> =

> Anyone got any ideas on how to fix this?

That's very strange as it don't seems to have been change on multiproto
since my last patch the 13 of this month. Or you mean my patch is wrong ?
"Working HVR-4000 (as of 2008-03-13) patch for multiproto ?"

http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024487.html

If my patch is wrong, it's a funny way to tell me...
-- =

Gr=E9goire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.o=
rg
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
