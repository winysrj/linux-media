Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1JyJMQ-0004w8-5A
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 06:22:04 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1982687wag.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 21:21:55 -0700 (PDT)
Message-ID: <bb72339d0805192121l35b4d876j75bf913411d19ba4@mail.gmail.com>
Date: Tue, 20 May 2008 14:21:55 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <483230CA.7030204@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <bb72339d0805191836l26aa826fl3b6dd3aafa20712@mail.gmail.com>
	<483230CA.7030204@iki.fi>
Subject: Re: [linux-dvb] Kworld 399U Dual DVB-T USB tuner
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

On 20/05/2008, Antti Palosaari <crope@iki.fi> wrote:
> Owen Townend wrote:
>
> > So two questions:
> >  What can I do to enable the second tuner on the dongle?
> >  How can I compile the cx88 drivers along with the rest in the af9015
> checkout?
> >
>
>
> > [4] http://linuxtv.org/hg/~anttip/af9015/rev/22fc34924b9e
> >
>
>  You should use newer tree:
>  http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/
>  I have feeling that both tuners should work (if I have not broken
> something)...
>
>  regards
>  Antti

Hey,
  Thanks for the reply.
  I've rebuilt from the suggested tree and this does indeed give me
access to both tuners on the USB stick. Thankyou for the ongoing work!
  Unfortunately the cx88 drivers are still not being compiled along
with the rest. Any suggestions?

cheers,
Owen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
