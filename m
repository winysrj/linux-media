Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1KTz0n-0001wa-Fv
	for linux-dvb@linuxtv.org; Fri, 15 Aug 2008 15:06:38 +0200
Received: by ug-out-1314.google.com with SMTP id y2so316608uge.11
	for <linux-dvb@linuxtv.org>; Fri, 15 Aug 2008 06:06:33 -0700 (PDT)
Date: Fri, 15 Aug 2008 15:06:29 +0200
To: linux-dvb@linuxtv.org
Message-ID: <20080815130629.GB3270@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: [linux-dvb] [bcjenkins@tvwhere.com: Re: How to compil modules for	a
	non running kernel (liplianindvb) ?]
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

I got my answer :-)

I didn't know the make help : pretty usefull !!!

Thanks a lot ;-)

----- Forwarded message from Brandon Jenkins <bcjenkins@tvwhere.com> -----

Date: Fri, 15 Aug 2008 08:57:01 -0400
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] How to compil modules for a non running kernel (li=
plianindvb) ?
X-Status: A

On Fri, Aug 15, 2008 at 8:50 AM, Gregoire Favre
<gregoire.favre@gmail.com> wrote:
> Hello,
>
> is there a simple way to compil modules for a just compiled kernel
> before restarting into that kernel ?
>
> Thanks,
> --
> Gr=E9goire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg=
.org
>               http://picasaweb.google.com/Gregoire.Favre
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Yes. Assuming v4l-dvb dir:

>From make help:

make distclean
make release VER=3Dnew kernel eg. 2.6.26.2-custom
make
make install

Brandon

----- End forwarded message -----

-- =

Gr=E9goire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.o=
rg
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
