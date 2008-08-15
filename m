Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1KTyzg-0001um-2E
	for linux-dvb@linuxtv.org; Fri, 15 Aug 2008 15:05:28 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1312769nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 15 Aug 2008 06:05:24 -0700 (PDT)
Message-ID: <de8cad4d0808150605i78f70d75q4b72fdbd8cf196b8@mail.gmail.com>
Date: Fri, 15 Aug 2008 09:05:24 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Gregoire Favre" <gregoire.favre@gmail.com>
In-Reply-To: <20080815125047.GD3431@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080815125047.GD3431@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to compil modules for a non running kernel
	(liplianindvb) ?
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

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
