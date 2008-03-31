Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1JgIGB-0000we-1w
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 13:33:08 +0200
Message-ID: <47F0CBD2.8070209@dsl.pipex.com>
Date: Mon, 31 Mar 2008 04:32:34 -0700
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206957601.1318.linux-dvb@linuxtv.org>
	<47F0BDE4.4060205@dsl.pipex.com>
In-Reply-To: <47F0BDE4.4060205@dsl.pipex.com>
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

David Harvey wrote:
> Just a quick update.  I installed hardy (2.6.24) onto my mythbox (epia 
> mini itx) for testing and can confirm the same disconnect behaviour 
> with the bundled kernel presently, have not yet tried the latest 
> hg-src with this config.  The " hub 4-1:1.0: port 2 disabled by hub 
> (EMI?), re-enabling..." by which I mean the facility to re-enable 
> helps no end in requiring no reboot to reset the dvb device.
> I have a usb nova-t and nova-td (the latter of which I haven't tried 
> again yet).
>
> Will report back with results of up to date mercurial if there is any 
> likelihood of seeing a different result?
>
> Cheers,
>
> dh
>
I also just received the following response to a bug report I submitted 
through ubuntu which looks promising and relevant:

I'm experiencing the same problem with a DVB-T card on hardy. The fix
for it apparently is one-line, in one file:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81

Without this patch, my tuner card (a Hauppauge Nova-T 500 dual tuner)
disconnects multiple times a day, making Hardy Heron all but useless as
a MythTV platform. Can we please revisit the decision to push this patch
off to the next version?

-- USB port disabled by hup (EMI? re enabling) 
https://bugs.launchpad.net/bugs/204857 You received this bug 
notification because you are a direct subscriber of the bug.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
