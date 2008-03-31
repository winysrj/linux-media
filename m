Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eamonn.sullivan@gmail.com>) id 1JgIOx-0002Ak-TK
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 13:42:13 +0200
Received: by an-out-0708.google.com with SMTP id d18so2725066and.125
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 04:41:50 -0700 (PDT)
Message-ID: <e40e29dd0803310441i130d5583i840f1786a624c1f1@mail.gmail.com>
Date: Mon, 31 Mar 2008 12:41:50 +0100
From: "Eamonn Sullivan" <eamonn.sullivan@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <47F0CBD2.8070209@dsl.pipex.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.1.1206957601.1318.linux-dvb@linuxtv.org>
	<47F0BDE4.4060205@dsl.pipex.com> <47F0CBD2.8070209@dsl.pipex.com>
Subject: Re: [linux-dvb] Nova - T disconnects
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

On Mon, Mar 31, 2008 at 12:32 PM, David Harvey <dcharvey@dsl.pipex.com> wrote:
> David Harvey wrote:
>  > Just a quick update.  I installed hardy (2.6.24) onto my mythbox (epia
>  > mini itx) for testing and can confirm the same disconnect behaviour
>  > with the bundled kernel presently, have not yet tried the latest
>  > hg-src with this config.  The " hub 4-1:1.0: port 2 disabled by hub
>  > (EMI?), re-enabling..." by which I mean the facility to re-enable
>  > helps no end in requiring no reboot to reset the dvb device.
>  > I have a usb nova-t and nova-td (the latter of which I haven't tried
>  > again yet).
>  >
>  > Will report back with results of up to date mercurial if there is any
>  > likelihood of seeing a different result?
>  >
>  > Cheers,
>  >
>  > dh
>  >
>  I also just received the following response to a bug report I submitted
>  through ubuntu which looks promising and relevant:
>
>  I'm experiencing the same problem with a DVB-T card on hardy. The fix
>  for it apparently is one-line, in one file:
>
>  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81
>
>  Without this patch, my tuner card (a Hauppauge Nova-T 500 dual tuner)
>  disconnects multiple times a day, making Hardy Heron all but useless as
>  a MythTV platform. Can we please revisit the decision to push this patch
>  off to the next version?
>

That was me, in response to the previous comment on that bug report:
the developer rejected it, saying the patch will be applied to the
next version of Ubuntu instead. I think it'll be more promising
when/if the maintainer of Ubuntu's kernel replies.

-Eamonn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
