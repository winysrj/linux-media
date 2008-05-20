Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1JyJgR-0006NK-SW
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 06:42:47 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2097596rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 21:42:39 -0700 (PDT)
Message-ID: <bb72339d0805192142g629c8595h821335669cd33034@mail.gmail.com>
Date: Tue, 20 May 2008 14:42:39 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <bb72339d0805192121l35b4d876j75bf913411d19ba4@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <bb72339d0805191836l26aa826fl3b6dd3aafa20712@mail.gmail.com>
	<483230CA.7030204@iki.fi>
	<bb72339d0805192121l35b4d876j75bf913411d19ba4@mail.gmail.com>
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

On 20/05/2008, Owen Townend <owen.townend@gmail.com> wrote:
> On 20/05/2008, Antti Palosaari <crope@iki.fi> wrote:
>  > Owen Townend wrote:
>  >
>  > > So two questions:
>  > >  What can I do to enable the second tuner on the dongle?
>  > >  How can I compile the cx88 drivers along with the rest in the af9015
>  > checkout?
>  > >
>  >
>  >
>  > > [4] http://linuxtv.org/hg/~anttip/af9015/rev/22fc34924b9e
>  > >
>  >
>  >  You should use newer tree:
>  >  http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/
>  >  I have feeling that both tuners should work (if I have not broken
>  > something)...
>  >
>  >  regards
>  >  Antti
>
>
> Hey,
>   Thanks for the reply.
>   I've rebuilt from the suggested tree and this does indeed give me
>  access to both tuners on the USB stick. Thankyou for the ongoing work!
>   Unfortunately the cx88 drivers are still not being compiled along
>  with the rest. Any suggestions?
>

Quick followup:
  I had checked access to the dual tuners by listing /dev/dvb and
seeing two adapters. Both tuners are indeed useable in mythtv, but the
output is artifacted and jittery. The output when I only had access to
the single usb tuner was smooth. The hardware should be more than
adaquate (4GB RAM + phenom 9600 on 480G chipset) so it shouldn't be
that. This leaves me with the driver or firmware. What firmware should
I be using? Is the generic firmware I have[1] sufficient or should I
try to use a file from the windows driver disk?

cheers,
Owen.

[1] Firmware from:
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
